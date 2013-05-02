/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch07.dao;

import java.io.Serializable;

import com.springinpractice.ch07.domain.Forum;
import com.springinpractice.dao.Dao;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
public interface ForumDao extends Dao<Forum> {
	
	Forum get(Serializable id, boolean initMessages);
}
