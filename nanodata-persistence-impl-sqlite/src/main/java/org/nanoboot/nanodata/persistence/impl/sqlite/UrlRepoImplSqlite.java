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
import org.nanoboot.nanodata.entity.Url;
import org.nanoboot.nanodata.persistence.api.UrlRepo;
import org.nanoboot.nanodata.persistence.api.TextPosition;
import static org.nanoboot.nanodata.persistence.api.TextPosition.DOES_NOT_MATTER;
import static org.nanoboot.nanodata.persistence.api.TextPosition.LEFT;
import static org.nanoboot.nanodata.persistence.api.TextPosition.RIGHT;
import org.nanoboot.powerframework.time.moment.UniversalDateTime;

/**
 *
 * @author robertvokac
 */
public class UrlRepoImplSqlite implements UrlRepo {

    @Setter
    private SqliteConnectionFactory sqliteConnectionFactory;

    @Override
    public List<Url> list(int pageNumber, int pageSize, String urlLike, TextPosition textPosition, String itemId) {

        List<Url> result = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT * FROM ")
                .append(UrlTable.TABLE_NAME);

        sb.append(" WHERE 1=1");
        if (urlLike != null) {
            sb.append(" AND ").append(UrlTable.NAME);
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
        if (itemId != null) {
            sb.append(" AND ").append(UrlTable.ITEM_ID).append("=? ");

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

            if (urlLike != null) {
                stmt.setString(++i, urlLike);
            }
            if (itemId != null) {
                stmt.setString(++i, itemId);

            }
            stmt.setInt(++i, pageSize);
            stmt.setInt(++i, (pageNumber - 1) * pageSize);
            System.err.println(stmt.toString());
            rs = stmt.executeQuery();

            while (rs.next()) {
                result.add(extractUrlFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UrlRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(UrlRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return result;
    }

    private static Url extractUrlFromResultSet(final ResultSet rs) throws SQLException {
        return new Url(
                rs.getString(UrlTable.ID),
                rs.getString(UrlTable.URL),
                rs.getString(UrlTable.NAME),
                rs.getString(UrlTable.ITEM_ID),
                rs.getInt(UrlTable.OFFICIAL) != 0,
                rs.getString(UrlTable.CREATED_AT)
        );
    }

    @Override
    public String create(Url url) {
        if (url.getId() == null) {
            url.setId(UUID.randomUUID().toString());
        }
        if (url.getOfficial() == null) {
            url.setOfficial(false);
        }
        if (url.getName() == null) {
            url.setName("");
        }
        
        if (url.getUrl() != null) {
            url.setUrl(url.getUrl().trim());
        }
        if (url.getUrl() != null && url.getUrl().endsWith("/")) {
            url.setUrl(url.getUrl().substring(0, url.getUrl().length() - 1));
        }
        StringBuilder sb = new StringBuilder();
        sb
                .append("INSERT INTO ")
                .append(UrlTable.TABLE_NAME)
                .append("(")
                .append(UrlTable.ID).append(",")
                //
                .append(UrlTable.URL).append(",")
                .append(UrlTable.NAME).append(",")
                .append(UrlTable.ITEM_ID).append(",")
                .append(UrlTable.OFFICIAL).append(",")
                .append(UrlTable.CREATED_AT);

        sb.append(")")
                .append(" VALUES (?,?,?,  ?,?,?)");

        String sql = sb.toString();
        System.err.println(sql);
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {
            int i = 0;
            stmt.setString(++i, url.getId());
            stmt.setString(++i, url.getUrl());
            stmt.setString(++i, url.getName());
            //
            stmt.setString(++i, url.getItemId());
            stmt.setInt(++i, url.getOfficial() ? 1 : 0);
            stmt.setString(++i, UniversalDateTime.now().toString());

            //
            stmt.execute();
            System.out.println(stmt.toString());

            return url.getId();

        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UrlRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.err.println("Error.");
        return "";
    }

    @Override
    public Url read(String id) {
        if (id == null) {
            throw new RuntimeException("id is null");
        }
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT * FROM ")
                .append(UrlTable.TABLE_NAME)
                .append(" WHERE ")
                .append(UrlTable.ID)
                .append("=?");

        String sql = sb.toString();
        int i = 0;
        ResultSet rs = null;
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {

            stmt.setString(++i, id);

            rs = stmt.executeQuery();

            while (rs.next()) {
                return extractUrlFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UrlRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(UrlRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return null;
    }

    @Override
    public void update(Url url) {
        if (url.getOfficial() == null) {
            url.setOfficial(false);
        }
        if (url.getName() == null) {
            url.setName("");
        }
        if (url.getUrl() != null) {
            url.setUrl(url.getUrl().trim());
        }
        if (url.getUrl() != null && url.getUrl().endsWith("/")) {
            url.setUrl(url.getUrl().substring(0, url.getUrl().length() - 1));
        }

        StringBuilder sb = new StringBuilder();
        sb
                .append("UPDATE ")
                .append(UrlTable.TABLE_NAME)
                .append(" SET ")
                .append(UrlTable.URL).append("=?, ")
                .append(UrlTable.NAME).append("=?, ")
                .append(UrlTable.ITEM_ID).append("=?, ")
                .append(UrlTable.OFFICIAL).append("=? ")
                .append(" WHERE ").append(ItemTable.ID).append("=?");

        String sql = sb.toString();
        System.err.println(sql);
        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {
            int i = 0;
            stmt.setString(++i, url.getUrl());
            stmt.setString(++i, url.getName());
            stmt.setString(++i, url.getItemId());
            stmt.setInt(++i, url.getOfficial() ? 1 : 0);
            //
            stmt.setString(++i, url.getId());
            System.out.println(stmt.toString());
            int numberOfUpdatedRows = stmt.executeUpdate();
            System.out.println("numberOfUpdatedRows=" + numberOfUpdatedRows);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(UrlRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void delete(String id) {

        StringBuilder sb = new StringBuilder();
        sb
                .append("DELETE FROM ")
                .append(UrlTable.TABLE_NAME);
        sb.append(" WHERE ");

        sb.append(UrlTable.ID);
        sb.append("=?");
        String sql = sb.toString();
        System.err.println("SQL::" + sql);
        int i = 0;

        try (
                Connection connection = sqliteConnectionFactory.createConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {

            stmt.setString(++i, id);

            System.err.println(stmt.toString());
            stmt.execute();

        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(StatementRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
