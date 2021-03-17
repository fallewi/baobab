<%--

    Copyright (C) 2016-2019 Code Defenders contributors

    This file is part of Code Defenders.

    Code Defenders is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or (at
    your option) any later version.

    Code Defenders is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Code Defenders. If not, see <http://www.gnu.org/licenses/>.

--%>

<%@page import="org.codedefenders.util.Paths"%>
<%@ page import="org.codedefenders.game.Role" %>
<%@ page import="org.codedefenders.model.Feedback" %>
<%@ page import="org.codedefenders.model.Player" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.codedefenders.model.Feedback.Type" %>

<jsp:useBean id="login" class="org.codedefenders.beans.user.LoginBean" scope="request"/>
<jsp:useBean id="playerFeedback" class="org.codedefenders.beans.game.PlayerFeedbackBean" scope="request"/>

<div id="playerFeedback" class="modal fade" role="dialog" style="z-index: 10000; position: absolute;">

    <style>
        fieldset, label {
            margin: 0;
            padding: 0;
        }

        /****** Style Star Rating Widget *****/
        .rating {
            border: none;
            float: left;
        }

        .rating > input {
            display: none;
        }

        .rating > label:before {
            font-size: 1.25em;
            display: inline-block;
            content: "\e006";
            font-family: 'Glyphicons Halflings';
            font-style: normal;
            font-weight: normal;
        }

        .rating > label {
            font-size: 20px;
            color: #ddd;
            float: right;
        }

        /***** CSS Magic to Highlight Stars on Hover *****/
        .rating > input:checked ~ label, /* show gold star when clicked */
        .rating:not(:checked) > label:hover, /* hover current star */
        .rating:not(:checked) > label:hover ~ label {
            color: #FFD700;
        }

        /* hover previous stars in list */
        .rating > input:checked + label:hover, /* hover current star when changing rating */
        .rating > input:checked ~ label:hover,
        .rating > label:hover ~ input:checked ~ label, /* lighten current selection */
        .rating > input:checked ~ label:hover ~ label {
            color: #FFED85;
        }
    </style>

    <div class="modal-dialog modal-lg">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h3 class="modal-title">Feedback for Game ${playerFeedback.gameId}
                </h3>
            </div>

            <% if (playerFeedback.canGiveFeedback()) {%>
            <ul class="nav nav-tabs">
                <li class="active" id="provideFeedbackLink">
                    <a onClick="switchModal()">
                        Give Feedback
                    </a>
                </li>
                <li id="viewFeedbackLink">
                    <a onClick="switchModal()">
                        View Feedback
                    </a>
                </li>
            </ul>

            <div class="modal-body" id="provide_feedback_modal">
                <h4><b>How much do you agree with the following statements:</b></h4>
                <br>

                <form id="sendFeedback" action="<%=request.getContextPath() + Paths.API_FEEDBACK%>" method="post">
                    <input type="hidden" name="formType" value="sendFeedback">
                    <input type="hidden" name="gameId" value="${playerFeedback.gameId}">
                    <table class="table-hover table-striped table-responsive ">
                        <tbody>

                        <%
                            Map<Feedback.Type, Integer> ratings = playerFeedback.getOwnRatings();
                            for (Type type : playerFeedback.getAvailableFeedbackTypes()) {
                                int oldValue = ratings.getOrDefault(type, 0);
                        %>

                        <tr>
                            <td><%=type.description()%>
                            </td>
                            <td>
                                <fieldset class="rating">
                                    <input type="radio" id="star5_<%=type.name()%>" name="rating<%=type.name()%>" value=5
                                        <%=oldValue == 5 ? "checked" : ""%>>
                                    <label class="full" for="star5_<%=type.name()%>" title="very much"></label>
                                    <input type="radio" id="star4_<%=type.name()%>" name="rating<%=type.name()%>" value=4
                                        <%=oldValue == 4 ? "checked" : ""%>>
                                    <label class="full" for="star4_<%=type.name()%>" title="a lot"></label>
                                    <input type="radio" id="star3_<%=type.name()%>" name="rating<%=type.name()%>" value=3
                                        <%=oldValue == 3 ? "checked" : ""%>>
                                    <label class="full" for="star3_<%=type.name()%>" title="somewhat"></label>
                                    <input type="radio" id="star2_<%=type.name()%>" name="rating<%=type.name()%>" value=2
                                        <%=oldValue == 2 ? "checked" : ""%>>
                                    <label class="full" for="star2_<%=type.name()%>" title="a bit"></label>
                                    <input type="radio" id="star1_<%=type.name()%>" name="rating<%=type.name()%>" value=1
                                        <%=oldValue == 1 ? "checked" : ""%>>
                                    <label class="full" for="star1_<%=type.name()%>" title="not at all"></label>
                                </fieldset>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>

                    </table>

                    <br>
                    <p>In providing feedback you help us improve gameplay mechanics, <br>
                        hone match making and select classes that are engaging and fun.</p>
                    <p>You can change your feedback even after the game finishes.</p>
                    <p>Thank you for your time.</p>
                    <br>

                    <button class="btn btn-primary" type="submit" ${playerFeedback.hasOwnRatings() ? "" : "disabled"}>
                        Save Feedback
                    </button>
                </form>
            </div>
            <%}%>

            <div class="modal-body" id="view_feedback_modal"
                 style="${playerFeedback.canGiveFeedback() ? "display: none;" : ""}">

                <% if (playerFeedback.getAllRatings().size() > 0) { %>
                <div class="table-responsive">
                <table class="table-striped table-hover table-bordered table-responsive table-sm">
                    <thead>
                    <tr>
                        <th>${playerFeedback.canSeeFeedback() ? "Player" : ""}</th>
                        <% for (Type f : Type.values()) {%>
                            <th style="width: 12.5%" title="<%=f.description()%>"><%=f.displayName()%>
                            </th>
                        <%}%>
                    </tr>
                    </thead>
                    <tbody>

                    <%
                        if (playerFeedback.canSeeFeedback()) {
                            for (Map.Entry<Player, Map<Feedback.Type, Integer>> entry : playerFeedback.getAllRatings().entrySet()) {
                                Player player = entry.getKey();
                                Map<Feedback.Type, Integer> ratings = entry.getValue();

                                String rowColor = player.getRole() == Role.ATTACKER ? "#9a002914" : "#0029a01a";
                    %>
                    <tr style="background-color:<%=rowColor%>">
                        <td><%=player.getUser().getUsername()%></td>
                        <%
                            for (Type type : Feedback.Type.TYPES) {
                                Integer ratingValue = ratings.get(type);
                                if (ratingValue == null) {
                        %>
                        <td></td>

                        <%} else {%>

                        <td>
                            <fieldset class="rating">
                                <% for (int i = Feedback.MAX_RATING; i > 0; i--) { %>
                                <label class="full" title="<%=i%>"
                                       style="font-size:9px; color:<%=i <= ratingValue  ? "#FFD700" : "#bdbdbd"%>"></label>
                                <% } %>
                            </fieldset>
                        </td>

                        <%
                                }
                            }
                        %>
                    </tr>

                    <%
                            }
                        }
                    %>
                    <tr></tr>
                    <tr>
                        <td>Average</td>
                        <%
                            Map<Feedback.Type, Double> averageRatings = playerFeedback.getAverageRatings();
                            for (Type type : Type.TYPES) {
                                Double rating = averageRatings.get(type);
                                if (rating == null) {
                        %>
                        <td></td>

                        <% } else { %>

                        <td>
                            <p style="text-align: left;"><%=String.format("%.1f", rating)%></p>
                            <fieldset class="rating">
                                <%for (int i = Feedback.MAX_RATING; i > 0; i--) {%>
                                <label class="full" title="<%=i%>"
                                       style="font-size:9px; color:<%=i <= Math.round(rating)  ? "#FFD700" : "#bdbdbd"%>"></label>
                                <%}%>
                            </fieldset>
                        </td>

                        <%
                                }
                            }
                        %>
                    </tr>
                    </tbody>

                </table>
                </div>
                <% } else {
                %>
                <h4>No player has provided feedback for this game yet.</h4>
                <%
                    }%>
            </div>
        </div>
    </div>
</div>

<script>
    function switchModal() {
        var provideFeedbackModalStyle = document.getElementById('provide_feedback_modal').style.display;
        document.getElementById('view_feedback_modal').style.display = provideFeedbackModalStyle;
        document.getElementById('provide_feedback_modal').style.display = provideFeedbackModalStyle == 'none' ? 'block' : 'none';
        document.getElementById('view_feedback_modal').style.width = "90%";
        document.getElementById('view_feedback_modal').style.margin = "0 auto";
        document.getElementById('provideFeedbackLink').classList.toggle('active');
        document.getElementById('viewFeedbackLink').classList.toggle('active');
    }

    $(document).ready(() => {
        $('#sendFeedback').on('change', '.rating input', function () {
            $('#sendFeedback button[type="submit"]').removeAttr('disabled');
        });
    });
</script>
