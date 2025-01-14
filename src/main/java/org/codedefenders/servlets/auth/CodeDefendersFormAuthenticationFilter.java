package org.codedefenders.servlets.auth;

import java.io.IOException;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.codedefenders.beans.message.MessagesBean;
import org.codedefenders.beans.user.LoginBean;
import org.codedefenders.model.UserEntity;
import org.codedefenders.service.UserService;
import org.codedefenders.util.Paths;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.net.InetAddresses;

/**
 * This filter performs the login with the form data submitted via a HTTP POST request to the {@code /login} url.
 *
 * <p>The whole authentication logic is handled silently by the parent class {@link FormAuthenticationFilter} which
 * performs a login against the {@link org.codedefenders.auth.CodeDefendersAuthenticatingRealm} with the credentials
 * found in the {@code username} and {@code password} HTML parameters of the POST request.
 */
public class CodeDefendersFormAuthenticationFilter extends FormAuthenticationFilter {
    private static final Logger logger = LoggerFactory.getLogger(CodeDefendersFormAuthenticationFilter.class);

    private final LoginBean login;
    private final MessagesBean messages;
    private final UserService userService;

    public CodeDefendersFormAuthenticationFilter(LoginBean login, MessagesBean messages,
            UserService userService) {
        this.login = login;
        this.messages = messages;
        this.userService = userService;
    }

    @Override
    protected boolean onLoginSuccess(AuthenticationToken token, Subject subject, ServletRequest request,
            ServletResponse response) throws Exception {
        // Make sure that the session and the like are correctly configured

        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpServletRequest httpRequest = (HttpServletRequest) request;

        // From LoginFilter
        /*
         * Disable caching in the HTTP header.
         * https://stackoverflow.com/questions/13640109/how-to-prevent-browser-cache-for
         * -php-site
         */
        httpResponse.setHeader("Pragma", "No-cache");
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setDateHeader("Expires", -1);

        final int userId = ((UserEntity) subject.getPrincipal()).getId();
        final String ipAddress = getClientIpAddress(httpRequest);

        // Log user activity including the timestamp
        userService.recordSession(userId, ipAddress);
        logger.info("Successful login for username '{}' from ip {}", token.getPrincipal(), ipAddress);

        login.loginUser((UserEntity) subject.getPrincipal());

        // Call the super method, as this is the one doing the redirect after a successful login.
        return super.onLoginSuccess(token, subject, request, response);
    }

    @Override
    protected boolean onLoginFailure(AuthenticationToken token, AuthenticationException e, ServletRequest request,
            ServletResponse response) {

        messages.add("Username not found or password incorrect.");

        if (request instanceof HttpServletRequest
                && response instanceof HttpServletResponse) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpServletResponse httpResponse = (HttpServletResponse) response;

            final String ipAddress = getClientIpAddress(httpRequest);

            if (e instanceof IncorrectCredentialsException) {
                logger.warn("Failed login with wrong password for username '{}' from ip {}", token.getPrincipal(), ipAddress);
            } else if (e instanceof UnknownAccountException) {
                logger.warn("Failed login for non-existing username '{}' from ip {}", token.getPrincipal(), ipAddress);
            } else {
                logger.warn("Failed login for username '{}' from ip {}", token.getPrincipal(), ipAddress);
            }

            try {
                httpResponse.sendRedirect(httpRequest.getContextPath() + Paths.LOGIN);
            } catch (IOException ioException) {
                logger.error("TODO", e);
            }
        }

        return false;
    }

    @Override
    protected void saveRequest(ServletRequest request) {
        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            // Don't save request in this case because otherwise user is redirected to an API url on successful login
            if (httpRequest.getRequestURI().startsWith("/api/")) {
                return;
            }
        }
        super.saveRequest(request);
    }

    private String getClientIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (invalidIP(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (invalidIP(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (invalidIP(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (invalidIP(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (invalidIP(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    private boolean invalidIP(String ip) {
        //noinspection UnstableApiUsage
        return (ip == null)
                || (ip.length() == 0)
                || ("unknown".equalsIgnoreCase(ip))
                || ("0:0:0:0:0:0:0:1".equals(ip))
                || !InetAddresses.isInetAddress(ip);
    }
}
