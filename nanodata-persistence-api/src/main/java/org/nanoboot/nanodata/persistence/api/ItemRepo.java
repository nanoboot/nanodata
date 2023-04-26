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
import org.nanoboot.nanodata.entity.Item;

/**
 *
 * @author robertvokac
 */
public interface ItemRepo {
    List<Item> list(int pageNumber, int pageSize, String labelLike, TextPosition textPosition);
        
    String create(Item item);
    Item read(String id);
    String getLabel(String id);
    void update(Item item);
    default void delete(Item item) {
        throw new UnsupportedOperationException();
    }
    
}
