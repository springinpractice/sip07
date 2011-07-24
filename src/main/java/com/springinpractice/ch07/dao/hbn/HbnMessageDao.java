package com.springinpractice.ch07.dao.hbn;

import org.springframework.stereotype.Repository;

import com.springinpractice.ch07.dao.MessageDao;
import com.springinpractice.ch07.domain.Message;
import com.springinpractice.dao.hibernate.AbstractHbnDao;

@Repository
public class HbnMessageDao extends AbstractHbnDao<Message> implements MessageDao { }
