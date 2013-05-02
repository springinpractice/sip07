/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch07.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Controller
public class PortalController {
	
	// Use this instead of <mvc:view-controller> so we can handle all HTTP methods and not just GET. (Forwarding to the
	// access denied page preserves the HTTP request method.)
	@RequestMapping(value = "/accessdenied.html")
	public String getAccessDenied() { return "accessdenied"; }
}
