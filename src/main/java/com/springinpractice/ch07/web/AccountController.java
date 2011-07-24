package com.springinpractice.ch07.web;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.springinpractice.ch07.domain.Account;
import com.springinpractice.ch07.service.AccountService;

@Controller
public class AccountController {
	@Inject private AccountService accountService;
	
	@RequestMapping(value = "/accounts/{username}", method = RequestMethod.GET)
	public String getAccountInfo(@PathVariable("username") String username, Model model) {
		Account account = accountService.getAccountByUsername(username);
		model.addAttribute(account);
		return "accounts/account";
	}
}
