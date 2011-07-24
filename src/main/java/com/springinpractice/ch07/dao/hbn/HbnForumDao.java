package com.springinpractice.ch07.dao.hbn;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import com.springinpractice.ch07.dao.ForumDao;
import com.springinpractice.ch07.domain.Forum;
import com.springinpractice.dao.hibernate.AbstractHbnDao;
import com.springinpractice.util.NumberUtils;

@Repository
public class HbnForumDao extends AbstractHbnDao<Forum> implements ForumDao {
	
	@Override
	@SuppressWarnings("unchecked")
	public List<Forum> getAll() {
		Session session = getSession();
		Query query = session.getNamedQuery("getForumsWithStats");
		List<Object[]> results = query.list();
		
		List<Forum> forums = new ArrayList<Forum>();
		for (Object[] result : results) {
			Forum forum = (Forum) result[0];
			forum.setCalculateMessageStats(false);
			forum.setNumVisibleMessages(NumberUtils.asInt((Long) result[1]));
			forum.setLastVisibleMessageDate((Date) result[2]);
			forums.add(forum);
		}
		
		return forums;
	}

	public Forum get(Serializable id, boolean initMessages) {
		Forum forum = get(id);
		if (initMessages) {
			Hibernate.initialize(forum.getMessages());
		}
		return forum;
	}
}
