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

import java.util.logging.Level;
import java.util.logging.Logger;
import org.nanoboot.dbmigration.core.main.DBMigration;

/**
 *
 * @author robertvokac
 */
public class SqliteDatabaseMigration {

    private final String jdbcUrl = "jdbc:sqlite:" + System.getProperty("nanodata.confpath") + "/" + "nanodata.sqlite?foreign_keys=on;";

    public void migrate() {
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(SqliteDatabaseMigration.class.getName()).log(Level.SEVERE, null, ex);
            throw new RuntimeException(ex);
        }
        System.err.println("jdbcUrl=" + jdbcUrl);
        String clazz = this.getClass().getName();
        DBMigration dbMigration = DBMigration
                .configure()
                .dataSource(this.jdbcUrl)
                .installedBy("nanodata-persistence-sqlite-impl")
                .name("nanodata")
                .sqlDialect("sqlite", "org.nanoboot.dbmigration.core.persistence.impl.sqlite.DBMigrationPersistenceSqliteImpl")
                .sqlMigrationsClass(clazz)
                .load();
        dbMigration.migrate();
    }

}
