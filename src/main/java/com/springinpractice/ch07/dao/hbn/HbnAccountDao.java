package com.springinpractice.ch07.dao.hbn;

import org.hibernate.Query;
import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import com.springinpractice.ch07.dao.AccountDao;
import com.springinpractice.ch07.domain.Account;
import com.springinpractice.dao.hibernate.AbstractHbnDao;

@Repository("accountDao")
public class HbnAccountDao extends AbstractHbnDao<Account> implements AccountDao {
	
	public Account getByUsername(String username) {
		Assert.notNull(username, "username can't be null");
		Query query = getSession().getNamedQuery("account.byUsername");
		query.setParameter("username", username);
		return (Account) query.uniqueResult();
	}

	@Transactional
	public UserDetails loadUserByUsername(String username)
		throws UsernameNotFoundException, DataAccessException {
		
		Assert.notNull(username, "username can't be null");
		Account account = getByUsername(username);
		if (account != null) {
			return account;
		} else {
			throw new UsernameNotFoundException("No user with username " + username);
		}
	}
}
