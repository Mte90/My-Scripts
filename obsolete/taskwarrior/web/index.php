<?php
	include("config.php");
	include("Task.php");
	include("functions.php");
?>
<html>
    <head>
    <title>My tasks</title>
    </head>
    <body>
        <div class="body">
            <?php
                $pending = parse_tasks($PENDING_DATA_PATH);
                $completed = parse_tasks($COMPLETED_DATA_PATH);

                sort_tasks($pending);
                sort_tasks($completed);

                display_by_projects($pending, $completed, $TITLE);
            ?>
        </div>
    </body>
</html>
