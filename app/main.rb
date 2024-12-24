def calculate_ball_speed(level)
  base_speed = 5
  speed_increase = 1.5
  [base_speed + (level - 1) * speed_increase, 15].min  # Cap at 15
end

def calculate_paddle_speed(level)
  base_speed = 8
  speed_increase = 0.5
  [base_speed + (level - 1) * speed_increase, 15].min  # Cap at 15
end

def tick args
  # Initialisierung (nur beim ersten Aufruf)
  args.state.level ||= 1
  args.state.points_for_level_up ||= 5
  args.state.max_level ||= 10
  
  initial_speed = calculate_ball_speed(args.state.level)
  args.state.ball ||= { x: 640, y: 360, w: 20, h: 20, dx: initial_speed, dy: initial_speed * 0.6 }
  args.state.left_paddle ||= { x: 50, y: 340, w: 20, h: 100 }
  args.state.right_paddle ||= { x: 1210, y: 340, w: 20, h: 100 }

  # Ballbewegung
  args.state.ball.x += args.state.ball.dx
  args.state.ball.y += args.state.ball.dy

  # Kollisionserkennung mit den Wänden
  if args.state.ball.y < 0 || args.state.ball.y + args.state.ball.h > 720  # Updated height boundary
    args.state.ball.dy = -args.state.ball.dy 
  end

  # Kollisionserkennung mit den Schlägern
  if args.state.ball.intersect_rect? args.state.left_paddle
    args.state.ball.dx = -args.state.ball.dx
  elsif args.state.ball.intersect_rect? args.state.right_paddle
    args.state.ball.dx = -args.state.ball.dx
  end

  # Punktvergabe, wenn der Ball die linke oder rechte Seite erreicht
  if args.state.ball.x < 0
    args.state.right_score ||= 0
    args.state.right_score += 1
    reset_ball_after_point(args)
  elsif args.state.ball.x + args.state.ball.w > 1280
    args.state.left_score ||= 0
    args.state.left_score += 1
    reset_ball_after_point(args)
  end

  # Update level based on total score
  total_score = (args.state.left_score || 0) + (args.state.right_score || 0)
  args.state.level = [(total_score / args.state.points_for_level_up) + 1, args.state.max_level].min

  # Steuerung der Schläger
  paddle_speed = calculate_paddle_speed(args.state.level)
  
  # Left paddle control (W and S keys)
  if args.inputs.keyboard.key_held.w
    args.state.left_paddle.y += paddle_speed
  elsif args.inputs.keyboard.key_held.s
    args.state.left_paddle.y -= paddle_speed
  end

  if args.inputs.keyboard.key_held.up
    args.state.right_paddle.y += paddle_speed
  elsif args.inputs.keyboard.key_held.down
    args.state.right_paddle.y -= paddle_speed
  end

  # Keep paddles within screen bounds
  args.state.left_paddle.y = args.state.left_paddle.y.clamp(0, 720 - args.state.left_paddle.h)
  args.state.right_paddle.y = args.state.right_paddle.y.clamp(0, 720 - args.state.right_paddle.h)

  # Zeichnen
  args.outputs.solids << args.state.ball
  args.outputs.solids << args.state.left_paddle
  args.outputs.solids << args.state.right_paddle

  # Anzeige des Punktestands (larger text and repositioned)
  args.outputs.labels << { 
    x: 540, 
    y: 650, 
    text: args.state.left_score.to_s,
    size_px: 50,                           # Larger text size
    alignment_enum: 1                      # Center aligned
  }
  
  args.outputs.labels << { 
    x: 740, 
    y: 650, 
    text: args.state.right_score.to_s,
    size_px: 50,                           # Larger text size
    alignment_enum: 1                      # Center aligned
  }

  # Display current level
  args.outputs.labels << {
    x: 640,
    y: 680,
    text: "Level: #{args.state.level}",
    size_px: 30,
    alignment_enum: 1
  }
end

def reset_ball_after_point(args)
  args.state.ball.x = 640
  args.state.ball.y = 360
  current_speed = calculate_ball_speed(args.state.level)
  # Randomize initial direction after point
  args.state.ball.dx = current_speed * (rand < 0.5 ? 1 : -1)
  args.state.ball.dy = current_speed * 0.6 * (rand < 0.5 ? 1 : -1)
end
