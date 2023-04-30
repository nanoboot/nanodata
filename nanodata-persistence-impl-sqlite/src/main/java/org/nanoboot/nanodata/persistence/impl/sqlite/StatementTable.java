///////////////////////////////////////////////////////////////////////////////////////////////
// Nanodata.
// Copyright (C) 2023-2023 the original author or authors.
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; version 2
// of the License only.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
///////////////////////////////////////////////////////////////////////////////////////////////
package org.nanoboot.nanodata.persistence.impl.sqlite;

/**
 *
 * @author robertvokac
 */
public class StatementTable {
    public static final String TABLE_NAME = "STATEMENT";
    
    public static final String ID = "ID";
    public static final String VALUE = "VALUE";
    public static final String SOURCE = "SOURCE";
    public static final String TARGET = "TARGET";
    public static final String CREATED_AT = "CREATED_AT";
    
    
    private StatementTable() {
        //Not meant to be instantiated.
    }

}
