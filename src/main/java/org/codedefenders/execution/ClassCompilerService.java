/*
 * Copyright (C) 2016-2019 Code Defenders contributors
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
package org.codedefenders.execution;

import java.io.File;

import org.codedefenders.game.GameClass;
import org.codedefenders.game.Mutant;
import org.codedefenders.game.Test;

public interface ClassCompilerService {

    /**
     * Compiles mutant
     * @param dir Mutant directory
     * @param jFile Java source file
     * @param gameID Game identifier
     * @param cut Class under test
     * @param ownerId User who submitted mutant
     * @return A {@link Mutant} object
     */
    Mutant compileMutant(File dir, String jFile, int gameID, GameClass cut, int ownerId);

    /**
     * Compiles test
     * @param dir Test directory
     * @param jFile Java source file
     * @param gameID Game identifier
     * @param cut Class under test
     * @param ownerId Player who submitted test
     * @return A {@link Test} object
     */
    Test compileTest(File dir, String jFile, int gameID, GameClass cut, int ownerId);

    /**
     * Compiles CUT
     *
     * @param cut Class under test
     * @return The path to the compiled CUT
     */
    String compileCUT(GameClass cut) throws CompileException;

    /**
     * Compiles generated test suite
     * @param cut Class under test
     */
    boolean compileGenTestSuite(final GameClass cut);

}
