package com.springinpractice.ch07.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.access.prepost.PostFilter;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.acls.domain.BasePermission;
import org.springframework.security.acls.domain.ObjectIdentityImpl;
import org.springframework.security.acls.domain.PrincipalSid;
import org.springframework.security.acls.model.MutableAcl;
import org.springframework.security.acls.model.MutableAclService;
import org.springframework.security.acls.model.ObjectIdentity;
import org.springframework.security.acls.model.Sid;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springinpractice.ch07.dao.ForumDao;
import com.springinpractice.ch07.dao.MessageDao;
import com.springinpractice.ch07.domain.Forum;
import com.springinpractice.ch07.domain.Message;
import com.springinpractice.ch07.service.ForumService;

/**
 * Basic {@link ForumService} implementation.
 *  
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Service
@Transactional
@PreAuthorize("denyAll")
public class ForumServiceImpl implements ForumService {
	private static Logger log = LoggerFactory.getLogger(ForumServiceImpl.class);
	
	@Inject private ForumDao forumDao;
	@Inject private MessageDao messageDao;
	@Inject private MutableAclService aclService;
	@Inject private MessageFilter messageFilter;
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch07.service.ForumService#getForums()
	 */
	@Override
	@PreAuthorize("hasRole('PERM_READ_FORUMS')")
	@PostFilter("hasPermission(filterObject, read)")
	public List<Forum> getForums() {
		return forumDao.getAll();
	}
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch07.service.ForumService#getForum(long, boolean)
	 */
	@Override
	@PreAuthorize("hasRole('PERM_READ_FORUMS')")
	@PostAuthorize("hasPermission(returnObject, read)")
	public Forum getForum(long id, boolean initMessages) {
		Forum forum = forumDao.get(id, initMessages);
		forum.setMessages(messageFilter.filter(forum.getMessages()));
		return forum;
	}
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch07.service.ForumService#createMessage(com.springinpractice.ch07.domain.Message)
	 */
	@Override
	@PreAuthorize("hasRole('PERM_CREATE_MESSAGES')")
	public void createMessage(Message message) {
		messageDao.create(message);
		createAcl(message);
	}
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch07.service.ForumService#getMessage(long)
	 */
	@Override
	@PreAuthorize("hasRole('PERM_READ_MESSAGES')")
	@PostAuthorize("(hasPermission(returnObject, read) and returnObject.visible) or hasPermission(returnObject, admin)")
	public Message getMessage(long id) {
		return messageDao.get(id);
	}
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch07.service.ForumService#setMessageSubjectAndText(com.springinpractice.ch07.domain.Message)
	 */
	@Override
	@PreAuthorize("(hasPermission(#message, write) and #message.visible) or hasPermission(#message, admin)")
	public void setMessageSubjectAndText(Message message) {
		Message pMessage = messageDao.get(message.getId());
		pMessage.setSubject(message.getSubject());
		pMessage.setText(message.getText());
		messageDao.update(pMessage);
		updateAcl(pMessage);
	}
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch07.service.ForumService#setMessageVisible(com.springinpractice.ch07.domain.Message)
	 */
	@Override
	@PreAuthorize("hasPermission(#message, admin)")
	public void setMessageVisible(Message message) {
		Message pMessage = messageDao.get(message.getId());
		pMessage.setVisible(message.isVisible());
		messageDao.update(pMessage);
		updateAcl(pMessage);
	}
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch07.service.ForumService#deleteMessage(com.springinpractice.ch07.domain.Message)
	 */
	@Override
	@PreAuthorize("hasPermission(#message, delete)")
	public void deleteMessage(Message message) {
		messageDao.delete(message);
		deleteAcl(message);
	}
	
	
	// =================================================================================================================
	// ACL helper methods
	// =================================================================================================================
	
	private void createAcl(Message message) {
		ObjectIdentity parentOid = new ObjectIdentityImpl(Forum.class, message.getForum().getId());
		log.debug("Loading ACL for forum OID: {}", parentOid);
		MutableAcl parentAcl = (MutableAcl) aclService.readAclById(parentOid);
		log.debug("Loaded forum ACL: {}", parentAcl);
		
		ObjectIdentity oid = new ObjectIdentityImpl(Message.class, message.getId());
		log.debug("Creating ACL for message OID: {}", oid);
		
		// This automatically makes the current principal the owner, at least with
		// the JDBC implementation.
		MutableAcl acl = aclService.createAcl(oid);
		
		Sid author = new PrincipalSid(message.getAuthor().getUsername());
		log.debug("Setting message owner: {}", author);
		
		// Checks against AclAuthorizationStrategy.CHANGE_GENERAL. This check
		// passes because the current principal is the ACL owner.
		acl.setParent(parentAcl);
		
		if (message.isVisible()) {
			// Checks against AclAuthorizationStrategy.CHANGE_GENERAL. Again
			// this check passes because the current principal is the ACL owner.
			acl.insertAce(0, BasePermission.WRITE, author, true);
		}
		
		// Checks against AclAuthorizationStrategy.CHANGE_OWNERSHIP. This
		// passes because the current principal is the ACL owner, but it won't
		// be after this call is done. Therefore do this last since we need to
		// own the ACL in order to change the parent and add the ACE.
		acl.setOwner(author);
		
		aclService.updateAcl(acl);
	}

	private void deleteAcl(Message message) {
		ObjectIdentity oid = new ObjectIdentityImpl(Message.class, message.getId());
		aclService.deleteAcl(oid, true);
	}

	private void updateAcl(Message message) {
		deleteAcl(message);
		createAcl(message);
	}
}
