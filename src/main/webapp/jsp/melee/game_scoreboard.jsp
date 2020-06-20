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
<%@page import="org.codedefenders.beans.game.ScoreItem"%>
<%@ page import="org.codedefenders.model.Player"%>
<%@ page import="java.util.List"%>
<%@ page import="org.codedefenders.util.Constants"%>
<%@ page import="org.codedefenders.database.TestDAO"%>
<%@ page import="org.codedefenders.database.MutantDAO"%>
<%@ page import="org.codedefenders.game.multiplayer.PlayerScore"%>
<%@ page import="org.codedefenders.model.User"%>
<%@ page import="java.util.Map"%>

<!-- This bean instance is shared with game_view.jsp -->
<jsp:useBean id="meeleScoreboard"
	class="org.codedefenders.beans.game.MeeleScoreboardBean"
	scope="request" />


<jsp:useBean id="login" class="org.codedefenders.beans.user.LoginBean"
	scope="request" />

<div id="scoreboard" class="modal fade" role="dialog"
	style="z-index: 10000; position: absolute;">
	<div class="modal-dialog">
		<!-- Modal content-->
		<div class="modal-content"
			style="z-index: 10000; position: absolute; width: 100%; left: 0%;">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">Scoreboard</h4>
			</div>
			<div class="modal-body">
				<div class="scoreBanner"></div>
				<table class="scoreboard">
					<!-- TODO Define proper formatting using melee class -->
					<thead class="thead-dark">
						<th>User</th>
						<th>Attack</th>
						<th>Defense</th>
						<th>Total Points</th>
					</thead>
					<!--  Use the tag library to go over the players instead of using java snippets -->
					<!-- TODO Sort by Total Score -->
					<!-- TODO Highglight current player -->
					<%
					    for (ScoreItem scoreItem : meeleScoreboard.getScoreItems()) {
					        // Highlight the row of the current player
					        if (login.getUserId() == scoreItem.getUser().getId()) {
					%>
					<tr class="table-active">
						<%
						    } else {
						%>
					
					<tr>
						<%
						    }
						%>
						<td><%=scoreItem.getUser().getUsername()%></td>
						<td><%=scoreItem.getAttackScore().getTotalScore()%></td>
						<td><%=scoreItem.getDefenseScore().getTotalScore()%></td>
						<td><%=scoreItem.getAttackScore().getTotalScore() + scoreItem.getDefenseScore().getTotalScore()%></td>
					</tr>
					<%
					    }
					%>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
