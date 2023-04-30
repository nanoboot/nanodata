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
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import lombok.Setter;
import org.nanoboot.nanodata.entity.Item;
import org.nanoboot.nanodata.persistence.api.ItemRepo;
import org.nanoboot.nanodata.persistence.api.TextPosition;
import static org.nanoboot.nanodata.persistence.api.TextPosition.LEFT;
import org.nanoboot.powerframework.time.moment.UniversalDateTime;

/**
 *
 * @author robertvokac
 */
public class ItemRepoImplSqlite implements ItemRepo {

    @Setter
    private SqliteConnectionFactory sqliteConnectionFactory;

    @Override
    public List<Item> list(int pageNumber, int pageSize, String labelLike, TextPosition textPosition) {

        List<Item> result = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT * FROM ")
                .append(ItemTable.TABLE_NAME);

        if (labelLike != null) {
            sb.append(" WHERE ").append(ItemTable.LABEL);
            switch (textPosition) {
                case LEFT:
                    sb.append(" LIKE ? || '%'");
                    break;
                case DOES_NOT_MATTER:
                    sb.append(" LIKE '%' || ? || '%'");
                    break;
                case RIGHT:
                    sb.append(" LIKE '%' || ?");
                    break;
                default:
                    throw new RuntimeException("Unsupported TextPosition: " + textPosition);
            }
        }
        {
            sb.append(" LIMIT ? OFFSET ? ");
        }
        String sql = sb.toString();
        System.err.println(sql);
        int i = 0;
        ResultSet rs = null;
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {

            if (labelLike != null) {
                stmt.setString(++i, labelLike);
            }
            stmt.setInt(++i, pageSize);
            stmt.setInt(++i, (pageNumber - 1) * pageSize);
            System.err.println(stmt.toString());
            rs = stmt.executeQuery();

            while (rs.next()) {
                result.add(extractItemFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ItemRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ItemRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return result;
    }

    private static Item extractItemFromResultSet(final ResultSet rs) throws SQLException {
        return new Item(
                rs.getString(ItemTable.ID),
                rs.getString(ItemTable.LABEL),
                rs.getString(ItemTable.DISAMBIGUATION),
                rs.getString(ItemTable.DESCRIPTION),
                rs.getString(ItemTable.URL),
                rs.getString(ItemTable.ATTRIBUTES),
                rs.getString(ItemTable.ALIASES),
                rs.getInt(ItemTable.ENTRY_POINT_ITEM) != 0
        );
    }

    @Override
    public String create(Item item) {
        if (item.getId() == null) {
            item.setId(UUID.randomUUID().toString());
        }
        if(item.getDisambiguation() == null) {
            item.setDisambiguation("");
        }
        StringBuilder sb = new StringBuilder();
        sb
                .append("INSERT INTO ")
                .append(ItemTable.TABLE_NAME)
                .append("(")
                .append(ItemTable.ID).append(",")
                //
                .append(ItemTable.LABEL).append(",")
                .append(ItemTable.DISAMBIGUATION).append(",")
                .append(ItemTable.DESCRIPTION).append(",")
                .append(ItemTable.URL).append(",")
                //
                .append(ItemTable.ATTRIBUTES).append(",")
                .append(ItemTable.ALIASES).append(",")
                .append(ItemTable.ENTRY_POINT_ITEM).append(",")
                .append(ItemTable.CREATED_AT);

        sb.append(")")
                .append(" VALUES (?, ?,?,?, ?, ?,?,?,?)");

        String sql = sb.toString();
        System.err.println(sql);
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {
            int i = 0;
            stmt.setString(++i, item.getId());
            //
            stmt.setString(++i, item.getLabel());
            stmt.setString(++i, item.getDisambiguation());
            stmt.setString(++i, item.getDescription());
            stmt.setString(++i, item.getUrl());
            //
            stmt.setString(++i, item.getAttributes());
            stmt.setString(++i, item.getAliases());
            stmt.setInt(++i, item.getEntryPointItem() ? 1 : 0);
            stmt.setString(++i, UniversalDateTime.now().toString());

            //
            stmt.execute();
            System.out.println(stmt.toString());

            return item.getId();

        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ItemRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.err.println("Error.");
        return "";
    }

    @Override
    public Item read(String id) {
        if (id == null) {
            throw new RuntimeException("id is null");
        }
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT * FROM ")
                .append(ItemTable.TABLE_NAME)
                .append(" WHERE ")
                .append(ItemTable.ID)
                .append("=?");

        String sql = sb.toString();
        int i = 0;
        ResultSet rs = null;
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {

            stmt.setString(++i, id);

            rs = stmt.executeQuery();

            while (rs.next()) {
                return extractItemFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ItemRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ItemRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return null;
    }

    @Override
    public void update(Item item) {
        if(item.getDisambiguation() == null) {
            item.setDisambiguation("");
        }
        
        StringBuilder sb = new StringBuilder();
        sb
                .append("UPDATE ")
                .append(ItemTable.TABLE_NAME)
                .append(" SET ")
                .append(ItemTable.LABEL).append("=?, ")
                .append(ItemTable.DISAMBIGUATION).append("=?, ")
                .append(ItemTable.DESCRIPTION).append("=?, ")
                .append(ItemTable.URL).append("=?, ")
                //
                .append(ItemTable.ATTRIBUTES).append("=?, ")
                .append(ItemTable.ALIASES).append("=?, ")
                .append(ItemTable.ENTRY_POINT_ITEM).append("=? ")
                .append(" WHERE ").append(ItemTable.ID).append("=?");

        String sql = sb.toString();
        System.err.println(sql);
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {
            int i = 0;
            stmt.setString(++i, item.getLabel());
            stmt.setString(++i, item.getDisambiguation());
            stmt.setString(++i, item.getDescription());
            stmt.setString(++i, item.getUrl());
            //
            stmt.setString(++i, item.getAttributes());
            stmt.setString(++i, item.getAliases());
            stmt.setBoolean(++i, item.getEntryPointItem() == null ? false : item.getEntryPointItem().booleanValue());
            //
            stmt.setString(++i, item.getId());

            int numberOfUpdatedRows = stmt.executeUpdate();
            System.out.println("numberOfUpdatedRows=" + numberOfUpdatedRows);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ItemRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getLabel(String id) {
        if (id == null) {
            throw new RuntimeException("id is null");
        }
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT ")
                .append(ItemTable.LABEL)
                .append(" FROM ")
                .append(ItemTable.TABLE_NAME)
                .append(" WHERE ")
                .append(ItemTable.ID)
                .append("=?");

        String sql = sb.toString();
        int i = 0;
        ResultSet rs = null;
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {

            stmt.setString(++i, id);

            rs = stmt.executeQuery();

            while (rs.next()) {
                return rs.getString(ItemTable.LABEL);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ItemRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ItemRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return "[unknown]";
    }

}
