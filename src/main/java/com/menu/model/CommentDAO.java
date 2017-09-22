package com.menu.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class CommentDAO extends SqlSessionDaoSupport {
	public void insert(CommentDTO commentDTO) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("board_num", commentDTO.getBoard_num());
		map.put("comment_num", commentDTO.getComment_num());

		getSqlSession().insert("inserComment", commentDTO);
		if (commentDTO.getComment_num() == 0)
			getSqlSession().update("updateCommentCount", map);
		else
			getSqlSession().update("updateReplyCount", map);
	}

	public CommentDTO get(int num) {
		return getSqlSession().selectOne("getComment", num);
	}

	public List<CommentDTO> list(int board_num, int comment_num) {
		Map<String, Object> map = new HashMap<String, Object>();

		if (board_num != 0)
			map.put("board_num", board_num);
		map.put("comment_num", comment_num);

		return getSqlSession().selectList("commentList", map);
	}

	public void update(CommentDTO commentDTO) {
		getSqlSession().update("updateComment", commentDTO);
	}

	public void delete(int num, int board_num) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("board_num", board_num);

		getSqlSession().delete("deleteComment", num);
		getSqlSession().update("updateCommentCount", map);
	}

	public void deleteReply(int num, int comment_num) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("comment_num", comment_num);

		getSqlSession().delete("deleteComment", num);
		getSqlSession().update("updateReplyCount", map);
	}

	public List<HashMap<String, Object>> getReplyCountOnDeleteMember(String nick) {
		return getSqlSession().selectList("getReplyCountOnDeleteMember", nick);
	}

	public List<HashMap<String, Object>> getCommentCountOnDeleteMember(String nick) {
		return getSqlSession().selectList("getCommentCountOnDeleteMember", nick);
	}

	public List<Integer> getCommetnNumOnDeleteBoard(int board_num) {
		return getSqlSession().selectList("getCommetnNumOnDeleteBoard", board_num);
	}

	public void updateReplyCount(int num, int countValue) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("num", num);
		map.put("countValue", countValue);

		getSqlSession().update("updateReplyCountOnDeleteMember", map);
	}

	public boolean find(String column, Object value) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("column", column);
		map.put("value", value);

		return getSqlSession().selectOne("findComment", map) != null;
	}
}
