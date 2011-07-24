package com.springinpractice.ch07.web;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.springinpractice.ch07.service.ForumService;

@Controller
public class ForumsController {
	@Inject private ForumService forumService;
	
	@RequestMapping(value = "/forums", method = RequestMethod.GET)
	public String getForums(Model model) {
		model.addAttribute(forumService.getForums());
		return "forums/forumList";
	}

	@RequestMapping(value = "/forums/{id}", method = RequestMethod.GET)
	public String getForum(@PathVariable("id") Long id, Model model) {
		model.addAttribute(forumService.getForum(id, true));
		return "forums/forum";
	}
}
