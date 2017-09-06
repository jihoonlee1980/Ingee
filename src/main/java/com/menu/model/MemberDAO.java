package com.menu.model;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class MemberDAO extends SqlSessionDaoSupport {
	public void insert(MemberDTO memberDTO) {
		try {
			getSqlSession().insert("inserMember", memberDTO);
			getSqlSession().commit();
		} catch (Exception e) {
			// TODO: handle exception
			getSqlSession().rollback();
		} finally {
			getSqlSession().close();
		}
	}
	
	public int checkMemberUsername(String username){
		int count = -1;
		try {
			count = getSqlSession().selectOne("checkMemberUsername", username);
			getSqlSession().commit();
		} catch (Exception e) {
			getSqlSession().rollback();
		} finally {
			getSqlSession().close();
		}
		return count;
	}

	public int checkMemberFilename(String saved_filename) {
		int count = -1;
		try {
			count = getSqlSession().selectOne("checkMemberFilename", saved_filename);
			getSqlSession().commit();
		} catch (Exception e) {
			getSqlSession().rollback();
		} finally {
			getSqlSession().close();
		}
		return count;
	}
}
