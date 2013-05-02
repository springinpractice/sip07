/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch07.dao.hbn;

import org.springframework.stereotype.Repository;

import com.springinpractice.ch07.dao.MessageDao;
import com.springinpractice.ch07.domain.Message;
import com.springinpractice.dao.hibernate.AbstractHbnDao;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Repository
public class HbnMessageDao extends AbstractHbnDao<Message> implements MessageDao { }
