package com.springinpractice.ch07.web;

import java.io.IOException;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.springinpractice.ch07.domain.Account;
import com.springinpractice.ch07.domain.Message;
import com.springinpractice.ch07.service.ForumService;

@Controller
public class MessageController {
	private static final Logger log = LoggerFactory.getLogger(MessageController.class);
	
	@Inject private ForumService forumService;
	
	@InitBinder("message")
	public void initBinder(WebDataBinder binder) {
		binder.setAllowedFields(new String[] { "subject", "text" });
	}
	
	@RequestMapping(value = "/forums/{forumId}/messages/{messageId}", method = RequestMethod.GET)
	public String getMessage(
			@PathVariable("forumId") Long forumId,
			@PathVariable("messageId") Long messageId,
			Model model) {
		
		model.addAttribute(getMessageVerifyForumId(forumId, messageId));
		return "forums/message";
	}
	
	@RequestMapping(value = "/forums/{forumId}/messages/post", method = RequestMethod.GET)
	public String getNewMessageForm(@PathVariable("forumId") Long forumId, Model model) {
		Message message = new Message();
		message.setForum(forumService.getForum(forumId, false));
		model.addAttribute(message);
		return "forums/newMessageForm";
	}
	
	@RequestMapping(value = "/forums/{forumId}/messages/{messageId}/edit", method = RequestMethod.GET)
	public String getEditMessageForm(
			@PathVariable("forumId") Long forumId,
			@PathVariable("messageId") Long messageId,
			Model model) {
		
		Message message = getMessageVerifyForumId(forumId, messageId);
		model.addAttribute("originalMessage", message);
		model.addAttribute(message);
		return "forums/editMessageForm";
	}
	
	@RequestMapping(value = "/forums/{forumId}/messages", method = RequestMethod.POST)
	public String postMessage(
			@PathVariable("forumId") Long forumId,
			@ModelAttribute @Valid Message message,
			BindingResult result) {
		
		message.setForum(forumService.getForum(forumId, false));
		
		if (result.hasErrors()) { return "forums/newMessageForm"; }
		
		SecurityContext securityCtx = SecurityContextHolder.getContext();
		Authentication authn = securityCtx.getAuthentication();
		message.setAuthor((Account) authn.getPrincipal());
		message.setVisible(true);
		forumService.createMessage(message);
		
		// Would normally set Location header and HTTP status 201, but we're
		// using the redirect-after-post pattern, which uses the Location header
		// and status code for redirection.
		return getRedirectToForumPath(forumId) + ".html";
	}
	
	@RequestMapping(value = "/forums/{forumId}/messages/{messageId}", method = RequestMethod.PUT)
	public String putMessage(
			@PathVariable("forumId") Long forumId,
			@PathVariable("messageId") Long messageId,
			@ModelAttribute @Valid Message messageDto,
			BindingResult result,
			Model model) {
				
		Message message = getMessageVerifyForumId(forumId, messageId);
			
		if (result.hasErrors()) {
			log.debug("Submitted message has validation errors");
			model.addAttribute("originalMessage", message);
			return "forums/editMessageForm";
		}
		
		log.debug("Message validated; updating message subject and text");
		message.setSubject(messageDto.getSubject());
		message.setText(messageDto.getText());
		forumService.setMessageSubjectAndText(message);
		
		return getRedirectToMessagePath(forumId, messageId) + "/edit.html?saved=true";
	}
	
	// Supports AJAX call.
	// HttpServletResponse tells Spring Web MVC that we're generating the
	// response ourselves (i.e., not forwarding to JSP).
	@RequestMapping(value = "/forums/{forumId}/messages/{messageId}/visible", method = RequestMethod.PUT)
	@ResponseStatus(HttpStatus.OK)
	public void putMessageVisible(
			@PathVariable("forumId") Long forumId,
			@PathVariable("messageId") Long messageId,
			@RequestParam("value") boolean value,
			HttpServletResponse res) {
		
		// See http://stackoverflow.com/questions/975929/firefox-error-no-element-found
		res.setContentType("text/plain");
		Message message = new Message(forumId, messageId);
		message.setVisible(value);
		forumService.setMessageVisible(message);
	}
	
	@RequestMapping(value = "/forums/{forumId}/messages/{messageId}", method = RequestMethod.DELETE)
	public String deleteMessage(
			@PathVariable("forumId") Long forumId,
			@PathVariable("messageId") Long messageId,
			HttpServletResponse res)
		throws IOException {
		
		forumService.deleteMessage(getMessageVerifyForumId(forumId, messageId));
		return getRedirectToForumPath(forumId) + ".html?deleted=true";
	}
	
	private Message getMessageVerifyForumId(Long forumId, Long messageId) {
		Message message = forumService.getMessage(messageId);
		Assert.isTrue(forumId.equals(message.getForum().getId()), "Forum ID mismatch");
		return message;
	}
	
	private String getRedirectToForumPath(Long forumId) {
		return "redirect:/forums/" + forumId;
	}
	
	private String getRedirectToMessagesPath(Long forumId) {
		return getRedirectToForumPath(forumId) + "/messages";
	}
	
	private String getRedirectToMessagePath(Long forumId, Long messageId) {
		return getRedirectToMessagesPath(forumId) + "/" + messageId;
	}
}
