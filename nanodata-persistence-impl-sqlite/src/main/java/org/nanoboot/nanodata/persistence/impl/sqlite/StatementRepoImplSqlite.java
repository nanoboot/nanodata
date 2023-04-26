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

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import lombok.Setter;
import org.nanoboot.nanodata.entity.Statement;
import org.nanoboot.nanodata.persistence.api.StatementRepo;

/**
 *
 * @author robertvokac
 */
public class StatementRepoImplSqlite implements StatementRepo {

    @Setter
    private SqliteConnectionFactory sqliteConnectionFactory;

    private static Statement extractStatementFromResultSet(final ResultSet rs) throws SQLException {
        return new Statement(
                rs.getString(StatementTable.ID),
                rs.getString(StatementTable.VALUE),
                rs.getString(StatementTable.SOURCE),
                rs.getString(StatementTable.TARGET)
        );
    }

    @Override
    public List<Statement> list(int pageNumber, int pageSize, String source, String target, String value) {

        List<Statement> result = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT * FROM ")
                .append(StatementTable.TABLE_NAME);
        if (source != null && source.isEmpty()) {
            source = null;
        }
        if (target != null && target.isEmpty()) {
            target = null;
        }
        if (value != null && value.isEmpty()) {
            value = null;
        }
        if (source != null || target != null || value != null) {
            sb.append(" WHERE 1=1");
        }
        if (source != null) {
            sb
                    .append(" AND ")
                    .append(StatementTable.SOURCE)
                    .append(" IN (SELECT ")
                    .append(ItemTable.TABLE_NAME)
                    .append(".")
                    .append(ItemTable.ID)
                    .append(" FROM ")
                    .append(ItemTable.TABLE_NAME)
                    .append(" WHERE ")
                    .append(ItemTable.LABEL)
                    .append(" LIKE '%' || ? || '%' ) ");

        }
        if (target != null) {
            sb
                    .append(" AND ")
                    .append(StatementTable.TARGET)
                    .append(" IN (SELECT ")
                    .append(ItemTable.TABLE_NAME)
                    .append(".")
                    .append(ItemTable.ID)
                    .append(" FROM ")
                    .append(ItemTable.TABLE_NAME)
                    .append(" WHERE ")
                    .append(ItemTable.LABEL)
                    .append(" LIKE '%' || ? || '%' ) ");

        }
        if (value != null) {
            sb
                    .append(" AND ")
                    .append(StatementTable.VALUE)
                    .append(" LIKE '%' || ? || '%'  ");

        }
        {
            sb.append(" LIMIT ? OFFSET ? ");
        }
        String sql = sb.toString();
        System.err.println("SQL::" + sql);
        int i = 0;
        ResultSet rs = null;
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {

//            if (labelLike != null) {
//                stmt.setString(++i, labelLike);
//            }
            if (source != null) {
                stmt.setString(++i, source);
            }
            if (target != null) {
                stmt.setString(++i, target);
            }
            if (value != null) {
                stmt.setString(++i, value);
            }
            stmt.setInt(++i, pageSize);
            stmt.setInt(++i, (pageNumber - 1) * pageSize);
            System.err.println(stmt.toString());
            rs = stmt.executeQuery();

            while (rs.next()) {
                result.add(extractStatementFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(StatementRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(StatementRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return result;
    }

    @Override
    public int create(Statement statement) {
//           if (item.getId() == null) {
//            item.setId(UUID.randomUUID().toString());
//        }
//        StringBuilder sb = new StringBuilder();
//        sb
//                .append("INSERT INTO ")
//                .append(ItemTable.TABLE_NAME)
//                .append("(")
//                .append(ItemTable.ID).append(",")
//                //
//                .append(ItemTable.LABEL).append(",")
//                .append(ItemTable.DISAMBIGUATION).append(",")
//                .append(ItemTable.DESCRIPTION).append(",")
//                //
//                .append(ItemTable.ATTRIBUTES).append(",")
//                .append(ItemTable.ALIASES).append(",")
//                .append(ItemTable.ENTRY_POINT_ITEM);
//
//        sb.append(")")
//                .append(" VALUES (?, ?,?,?,  ?,?,?)");
//
//        String sql = sb.toString();
//        System.err.println(sql);
//        try (
//                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {
//            int i = 0;
//            stmt.setString(++i, item.getId());
//            //
//            stmt.setString(++i, item.getLabel());
//            stmt.setString(++i, item.getDisambiguation());
//            stmt.setString(++i, item.getDescription());
//            //
//            stmt.setString(++i, item.getAttributes());
//            stmt.setString(++i, item.getAliases());
//            stmt.setInt(++i, item.getEntryPointItem() ? 1 : 0);
//
//            //
//            stmt.execute();
//            System.out.println(stmt.toString());
//
//            return item.getId();
//
//        } catch (SQLException e) {
//            System.out.println(e.getMessage());
//        } catch (ClassNotFoundException ex) {
//            Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        System.err.println("Error.");
//        return "";
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(Statement statement) {
         StringBuilder sb = new StringBuilder();
        sb
                .append("UPDATE ")
                .append(StatementTable.TABLE_NAME)
                .append(" SET ")
                .append(StatementTable.SOURCE).append("=?, ")
                .append(StatementTable.TARGET).append("=?, ")
                .append(StatementTable.VALUE).append("=? ")
                //
                .append(" WHERE ").append(StatementTable.ID).append("=?");

        String sql = sb.toString();
        System.err.println(sql);
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {
            int i = 0;
            stmt.setString(++i, statement.getSource());
            stmt.setString(++i, statement.getTarget());
            stmt.setString(++i, statement.getValue());
            //
            stmt.setString(++i, statement.getId());

            int numberOfUpdatedRows = stmt.executeUpdate();
            System.out.println("numberOfUpdatedRows=" + numberOfUpdatedRows);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(StatementRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        }
   
    }

    @Override
    public Statement read(String id) {
         if (id == null) {
            throw new RuntimeException("id is null");
        }
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT * FROM ")
                .append(StatementTable.TABLE_NAME)
                .append(" WHERE ")
                .append(StatementTable.ID)
                .append("=?");

        String sql = sb.toString();
        int i = 0;
        ResultSet rs = null;
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {

            stmt.setString(++i, id);

            rs = stmt.executeQuery();

            while (rs.next()) {
                return extractStatementFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(StatementRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(StatementRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return null;
        
    }

}
