package org.codedefenders.beans.user;

import java.io.Serializable;

import javax.annotation.ManagedBean;
import javax.enterprise.context.SessionScoped;

import org.codedefenders.model.UserEntity;
import org.codedefenders.util.Paths;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * <p>Keeps track of the logged in user and other login information (URL to redirect to after login).</p>
 * <p>Bean Name: {@code login}</p>
 */
@ManagedBean
@SessionScoped
public class LoginBean implements Serializable {
    private static final Logger logger = LoggerFactory.getLogger(LoginBean.class);

    private UserEntity user;
    private String redirectURL;

    public LoginBean() {
        user = null;
        redirectURL = null;
    }

    /**
     * Sets the given user as the logged in user for the session.
     * @param user The user to log in.
     */
    public void loginUser(UserEntity user) {
        this.user = user;
    }

    /**
     * Checks if an active user is logged in for this session.
     * @return If an active user is logged in for this session.
     */
    public boolean isLoggedIn() {
        return user != null && user.isActive();
    }

    /**
     * Returns the logged in user for the session.
     * @return The logged in user for the session.
     */
    public UserEntity getUser() {
        return user;
    }

    /**
     * Returns the id of the logged in user for the session.
     * @return The id of the logged in user for the session.
     */
    public int getUserId() {
        return user.getId();
    }

    /**
     * Sets the URL to redirect to after login, if the given URL points to an actual page
     * (i.e. not a resource or the notification URL).
     * @param redirectURL The URL to redirect to after login.
     */
    public void redirectAfterLogin(String redirectURL) {
        if (!redirectURL.endsWith(".ico")
                && !redirectURL.endsWith(".css")
                && !redirectURL.endsWith(".js")) {
            this.redirectURL = redirectURL;
        }
    }

    /**
     * Checks if a URL to redirect to after login is set.
     * @return If a URL to redirect to after login is set.
     */
    public boolean isRedirectAfterLogin() {
        return redirectURL != null;
    }

    /**
     * Returns the URL to redirect to after login.
     * @return The URL to redirect to after login.
     */
    public String getRedirectURL() {
        return redirectURL;
    }

    /**
     * Clears the URL to redirect to after login.
     */
    public void clearRedirectAfterLogin() {
        this.redirectURL = null;
    }
}
