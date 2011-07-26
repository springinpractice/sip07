package com.springinpractice.ch07.service.impl;

import java.util.List;

import org.springframework.security.access.prepost.PostFilter;
import org.springframework.stereotype.Component;

import com.springinpractice.ch07.domain.Message;

@Component
public class MessageFilter {

	@PostFilter("(hasPermission(filterObject, read) and filterObject.visible) or hasPermission(filterObject, admin)")
	public List<Message> filter(List<Message> messages) { return messages; }
}
