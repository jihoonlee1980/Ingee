package com.menu.model;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class MemberDAO extends SqlSessionDaoSupport {
	public MemberDTO get(int num) {
		return getSqlSession().selectOne("getMemberNum", num);
	}

	public MemberDTO get(String id) {
		return getSqlSession().selectOne("getMemberID", id);
	}

	public void insert(MemberDTO memberDTO) {
		getSqlSession().insert("inserMember", memberDTO);
	}

	public int checkMemberUsername(String username) {
		return getSqlSession().selectOne("checkMemberUsername", username);
	}

	public int checkMemberFilename(String saved_filename) {
		return getSqlSession().selectOne("checkMemberFilename", saved_filename);
	}
	
	public MemberDTO login(MemberDTO memberDTO){
		return getSqlSession().selectOne("loginMember", memberDTO);
	}
}
