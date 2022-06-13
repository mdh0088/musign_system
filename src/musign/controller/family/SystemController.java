package musign.controller.family;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import musign.classes.Utils;

@Controller
@RequestMapping("/family/system/*")
public class SystemController {

   private final Logger log = Logger.getLogger(this.getClass());
   
   
   @RequestMapping("/main")
   public ModelAndView main(HttpServletRequest request) {
      ModelAndView mav = new ModelAndView();
      mav.setViewName("/WEB-INF/pages/family/system/main");

      return mav;
      
      
      
   }
   
}