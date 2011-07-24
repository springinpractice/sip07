package com.springinpractice.ch07.dao;

import java.io.Serializable;

import com.springinpractice.ch07.domain.Forum;
import com.springinpractice.dao.Dao;

public interface ForumDao extends Dao<Forum> {
	
	Forum get(Serializable id, boolean initMessages);
}
