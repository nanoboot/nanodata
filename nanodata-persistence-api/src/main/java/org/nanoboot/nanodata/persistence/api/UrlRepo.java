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

package org.nanoboot.nanodata.persistence.api;

import java.util.List;
import org.nanoboot.nanodata.entity.Url;

/**
 *
 * @author robertvokac
 */
public interface UrlRepo {
    List<Url> list(int pageNumber, int pageSize, String urlLike, TextPosition textPosition, String itemId);
        
    String create(Url url);
    Url read(String id);
    void update(Url url);
    void delete(String id);
    
}
