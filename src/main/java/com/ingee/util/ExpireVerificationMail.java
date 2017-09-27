package com.ingee.util;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.menu.model.MemberDAO;
import com.menu.model.MemberDTO;

@Component
public class ExpireVerificationMail {
	@Autowired
	MemberDAO memberDAO;

	// final String path
	// ="/home/hosting_users/ingeefanclub/tomcat/webapps/ROOT/resources";
	final String path = "/home/ubuntu/apache-tomcat-8.0.46/webapps/ROOT/resources";
	// final String path =
	// "C:\\Users\\jihyun\\Desktop\\egov\\eGovFrameDev-3.6.0-64bit\\workspace\\InGeeFanClub\\src\\main\\webapp\\resources";

	@Scheduled(cron = "0/30 * * * * *")
	public void expireVerificationMail() {
		List<Integer> nums = memberDAO.expireMemberNum();

		for (Integer integer : nums) {
			MemberDTO memberDTO = memberDAO.get(integer);
			if (!memberDTO.getSaved_filename().equals("NO")) {
				File saved_file = new File(path + "/profile/" + memberDTO.getSaved_filename());
				if (saved_file.exists())
					saved_file.delete();
			}
		}

		memberDAO.expireVerificationMail();
	}
}
