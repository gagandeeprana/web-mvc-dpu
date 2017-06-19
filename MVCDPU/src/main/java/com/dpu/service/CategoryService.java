/**
 * 
 */
package com.dpu.service;

import java.util.List;

import com.dpu.entity.Category;
import com.dpu.model.CategoryReq;

/**
 * @author jagvir
 *
 */
public interface CategoryService {
	Object addCategory(CategoryReq categoryReq);

	Object update(Long id, CategoryReq categoryReq);

	Object delete(Long id);

	List<CategoryReq> getAll( );

	CategoryReq getOpenAdd();

	CategoryReq get(Long id);

	List<CategoryReq> getCategoryByCategoryName(String categoryName);
	
	Category getCategory(Long categoryId);

	List<CategoryReq> getSpecificData();

}
