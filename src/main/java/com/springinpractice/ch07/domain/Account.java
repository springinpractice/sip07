package com.springinpractice.ch07.domain;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

@Entity
@Table(name = "account")
@NamedQuery(
	name = "account.byUsername",
	query = "from Account a where a.username = :username")
@SuppressWarnings("serial")
public class Account implements UserDetails {
	public static final Account ACCOUNT = new Account("anonymous");
	
	private Long id;
	private String username;
	private String firstName;
	private String lastName;
	private String email;
	private String password;
	private boolean enabled;
	private Set<Role> roles = new HashSet<Role>();
	
	public Account() { }
	
	public Account(String username) { this.username = username; }
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	public Long getId() { return id; }
	
	@SuppressWarnings("unused")
	private void setId(Long id) { this.id = id; }
	
	/* (non-Javadoc)
	 * @see org.springframework.security.core.userdetails.UserDetails#getUsername()
	 */
	@Column(name = "username")
	public String getUsername() { return username; }
	
	public void setUsername(String username) { this.username = username; }
	
	@Column(name = "first_name")
	public String getFirstName() { return firstName; }
	
	public void setFirstName(String firstName) { this.firstName = firstName; }
	
	@Column(name = "last_name")
	public String getLastName() { return lastName; }
	
	public void setLastName(String lastName) { this.lastName = lastName; }
	
	@Transient
	public String getFullName() { return firstName + " " + lastName; }
	
	@Column(name = "email")
	public String getEmail() { return email; }
	
	public void setEmail(String email) { this.email = email; }

	/* (non-Javadoc)
	 * @see org.springframework.security.core.userdetails.UserDetails#getPassword()
	 */
	@Column(name = "password")
	public String getPassword() { return password; }
	
	public void setPassword(String password) { this.password = password; }

	/* (non-Javadoc)
	 * @see org.springframework.security.core.userdetails.UserDetails#isAccountNonExpired()
	 */
	@Transient
	public boolean isAccountNonExpired() { return true; }

	/* (non-Javadoc)
	 * @see org.springframework.security.core.userdetails.UserDetails#isAccountNonLocked()
	 */
	@Transient
	public boolean isAccountNonLocked() { return true; }

	/* (non-Javadoc)
	 * @see org.springframework.security.core.userdetails.UserDetails#isCredentialsNonExpired()
	 */
	@Transient
	public boolean isCredentialsNonExpired() { return true; }

	/* (non-Javadoc)
	 * @see org.springframework.security.core.userdetails.UserDetails#isEnabled()
	 */
	@Column(name = "enabled")
	public boolean isEnabled() { return enabled; }
	
	public void setEnabled(boolean enabled) { this.enabled = enabled; }
	
	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(
		name = "account_role",
		joinColumns = { @JoinColumn(name = "account_id") },
		inverseJoinColumns = { @JoinColumn(name = "role_id") })
	public Set<Role> getRoles() { return roles; }
	
	public void setRoles(Set<Role> roles) { this.roles = roles; }
	
	@Transient
	public Set<Permission> getPermissions() {
		Set<Permission> perms = new HashSet<Permission>();
		for (Role role : roles) { perms.addAll(role.getPermissions()); }
		return perms;
	}

	/* (non-Javadoc)
	 * @see org.springframework.security.core.userdetails.UserDetails#getAuthorities()
	 */
	@Transient
	public Collection<GrantedAuthority> getAuthorities() {
		Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();
		authorities.addAll(getRoles());
		authorities.addAll(getPermissions());
		return authorities;
	}
	
	/**
	 * <p>
	 * Returns the username.
	 * </p>
	 */
	public String toString() { return username; }
}
