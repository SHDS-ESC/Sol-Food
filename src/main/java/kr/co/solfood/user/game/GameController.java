package kr.co.solfood.user.game;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/user/game")
@Controller
public class GameController {
    @GetMapping("/roulette")
    public void roulette() { }

    @GetMapping("/climbing-ladder")
    public void climbingLadder(){ }
}
