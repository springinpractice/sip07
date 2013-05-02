/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch07.web;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.springinpractice.ch07.service.ForumService;

/**
 * Controller to get the forums list and details views.
 * 
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Controller
public class ForumsController {
	@Inject private ForumService forumService;
	
	/**
	 * Returns the forums list view.
	 * 
	 * @param model model
	 * @return logical view name
	 */
	@RequestMapping(value = "/forums", method = RequestMethod.GET)
	public String getForums(Model model) {
		model.addAttribute(forumService.getForums());
		return "forums/forumList";
	}

	/**
	 * Returns the requested forum's details view.
	 * 
	 * @param id forum ID
	 * @param model model
	 * @return logical view name
	 */
	@RequestMapping(value = "/forums/{id}", method = RequestMethod.GET)
	public String getForum(@PathVariable("id") Long id, Model model) {
		model.addAttribute(forumService.getForum(id, true));
		return "forums/forum";
	}
}
