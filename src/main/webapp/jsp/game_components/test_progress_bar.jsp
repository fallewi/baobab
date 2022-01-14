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
<jsp:useBean id="testProgressBar" class="org.codedefenders.beans.game.TestProgressBarBean" scope="request"/>

<script type="text/javascript" src="js/test_progress_bar.js"></script>

<script>
    /* Wrap in a function so it has it's own scope. */
    (function () {
        const progressElement = document.getElementById('progress');
        const gameId = ${testProgressBar.gameId};

        CodeDefenders.objects.testProgressBar = new CodeDefenders.classes.TestProgressBar(progressElement, gameId);
    })();
</script>

