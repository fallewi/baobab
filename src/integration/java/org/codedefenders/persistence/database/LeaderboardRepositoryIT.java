/*
 * Copyright (C) 2021 Code Defenders contributors
 *
 * This file is part of Code Defenders.
 *
 * Code Defenders is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or (at
 * your option) any later version.
 *
 * Code Defenders is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Code Defenders. If not, see <http://www.gnu.org/licenses/>.
 */

package org.codedefenders.persistence.database;

import java.sql.SQLException;

import org.codedefenders.DatabaseRule;
import org.codedefenders.DatabaseTest;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.experimental.categories.Category;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

@Category(DatabaseTest.class)
public class LeaderboardRepositoryIT {

    @Rule
    public DatabaseRule databaseRule = new DatabaseRule();

    private LeaderboardRepository leaderboardRepo;

    @Before
    public void setup() throws SQLException {
        leaderboardRepo = new LeaderboardRepository(databaseRule.getConnectionFactory());
    }

    @Test
    public void noLeaderboardEntries() {
        assertTrue(leaderboardRepo.getLeaderboard().isEmpty());
    }

    @Test
    public void noLeaderboardEntryForUserId() {
        assertFalse(leaderboardRepo.getScore(100).isPresent());
    }
}