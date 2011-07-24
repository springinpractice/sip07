package com.springinpractice.ch07.service;

import java.util.List;

import com.springinpractice.ch07.domain.Forum;
import com.springinpractice.ch07.domain.Message;

public interface ForumService {
	
	List<Forum> getForums();
	
	Forum getForum(long id, boolean initMessages);
	
	void createMessage(Message message);

	/**
	 * <p>
	 * Returns the requested message.
	 * </p>
	 * 
	 * @param id
	 *            message ID
	 * @return message
	 */
	Message getMessage(long messageId);
	
	/**
	 * <p>
	 * Updates the subject and text of the passed message, ignoring all other
	 * fields.
	 * </p>
	 * 
	 * @param message
	 */
	void setMessageSubjectAndText(Message message);
	
	void setMessageVisible(Message message);
	
	void deleteMessage(Message message);
}
