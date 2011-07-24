package com.springinpractice.ch07.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springinpractice.ch07.dao.ForumDao;
import com.springinpractice.ch07.dao.MessageDao;
import com.springinpractice.ch07.domain.Forum;
import com.springinpractice.ch07.domain.Message;
import com.springinpractice.ch07.service.ForumService;

@Service
@Transactional
@PreAuthorize("denyAll")
public class ForumServiceImpl implements ForumService {
	@Inject private ForumDao forumDao;
	@Inject private MessageDao messageDao;
	
	@Override
	@PreAuthorize("hasRole('PERM_READ_FORUMS')")
	public List<Forum> getForums() {
		return forumDao.getAll();
	}
	
	@Override
	@PreAuthorize("hasRole('PERM_READ_FORUMS')")
	public Forum getForum(long id, boolean initMessages) {
		return forumDao.get(id, initMessages);
	}
	
	@Override
	@PreAuthorize("hasRole('PERM_CREATE_MESSAGES')")
	public void createMessage(Message message) {
		messageDao.create(message);
	}
	
	@Override
	@PreAuthorize("hasRole('PERM_READ_MESSAGES')")
	public Message getMessage(long id) {
		return messageDao.get(id);
	}
	
	@Override
	@PreAuthorize("hasRole('PERM_UPDATE_MESSAGES')")
	public void setMessageSubjectAndText(Message message) {
		Message pMessage = messageDao.get(message.getId());
		pMessage.setSubject(message.getSubject());
		pMessage.setText(message.getText());
		messageDao.update(pMessage);
	}
	
	@Override
	@PreAuthorize("hasRole('PERM_ADMIN_MESSAGES')")
	public void setMessageVisible(Message message) {
		Message pMessage = messageDao.get(message.getId());
		pMessage.setVisible(message.isVisible());
		messageDao.update(pMessage);
	}
	
	@Override
	@PreAuthorize("hasRole('PERM_DELETE_MESSAGES')")
	public void deleteMessage(Message message) {
		messageDao.delete(message);
	}
}
