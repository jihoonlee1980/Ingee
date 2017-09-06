package com.menu.model;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class MemberDAO extends SqlSessionDaoSupport {
	public void insert(MemberDTO memberDTO) {
		getSqlSession().insert("inserMember", memberDTO);
	}

	public int checkMemberUsername(String username) {
		return getSqlSession().selectOne("checkMemberUsername", username);
	}

	public int checkMemberFilename(String saved_filename) {
		return getSqlSession().selectOne("checkMemberFilename", saved_filename);
	}
}
