<?php

function parse_tasks($file){
    //Open the pending tasks
    $file_handle = fopen($file, "r");

    //Parse all lines
    while (!feof($file_handle)) {
        $line = fgets($file_handle);
        $part = substr($line, 1, -2);
        $parts = explode("\"", $part);

        $task = new Task();

        for($i = 0; $i < sizeof($parts); $i += 2){
            $key = $parts[$i];
            $value = $parts[$i+1];

            $key = trim($key);
            $value = trim($value);

            switch($key){
                case "description:":
                  $task->description = from_url_as_link($value);
                  break;
                case "project:":
                  $task->project = $value;
                  break;
                case "entry:":
                  $task->entry = $value;
                  break;
                case "uuid:":
                   $task->uuid = $value;
                   break;
                case "tags:":
                   $task->tags = $value;
                   break;
            }
        }

        $tasks[] = $task;
    }

    //Close the file
    fclose($file_handle);

    return $tasks;
}

function from_url_as_link($string){
    $string = str_replace('\/','/',$string);
    $string = str_replace('&dquot;','',$string);
    $string = str_replace('&close;','',$string);
    $string = str_replace('&open;','',$string);
    $url = '@(http(s)?)?(://)?(([a-zA-Z])([-\w]+\.)+([^\s\.]+[^\s]*)+[^,.\s])@';
$string = preg_replace($url, '<a href="http$2://$4" target="_blank" title="$0">$0</a>', $string);

    return $string;
}

function cmp_task($a, $b){
    $cmp = strcasecmp($a->project, $b->project);

    if($cmp == 0){
        return strcasecmp($a->description, $b->description);
    } else {
        return $cmp;
    }
}

function sort_tasks(&$tasks){
    usort($tasks, "cmp_task");

}

function display_task($task){
    echo "  <li>" . $task->description . "</li>\n";
}

function section_header($title, $completion = -1){
    echo "<h3 style='margin-bottom: 0px;'>" . $title;
    if($completion > -1){
        echo " (Completed: " . $completion  . "%)";
    }
    echo "</h3>\n";
    echo " <ul style='margin-top: 0px;'>\n";
}

function section_footer(){
    echo " </ul>\n";
}

function display_by_projects(&$pending, &$completed, $title){
    page_header($title);

    $project = "";
    $first = 0;

    foreach($pending as $task){
        if($task->project == ""){
            $no_project[] = $task;

            continue;
        }

        if($task->project != $project){
            if($first == 1){
                section_footer();
            }

            if($first == 0){
                $first = 1;
            }

            section_header($task->project, project_completion($task->project, $pending, $completed));

            $project = $task->project;
        }

        display_task($task);
    }
    section_footer();

    if(count($no_projects) > 0){
        section_header("No projects");

        foreach($no_project as $task){
            display_task($task);
        }

        section_footer();
    }

}

function page_header($title){
    echo "<div>\n";
    echo "<h2 style=\"text-align:left;\">" . $title . "</h2>\n";
    echo "</div>\n";
}

function project_completion($project, &$pending, &$completed){
    $pending_cnt = 0.0;
    $completed_cnt = 0.0;

    foreach($pending as $task){
        if($task->project == $project){
            $pending_cnt += 1;
        }
    }

    foreach($completed as $task){
        if($task->project == $project){
            $completed_cnt += 1;
        }
    }

    return 100 * round($completed_cnt / ($pending_cnt + $completed_cnt), 2);
}

function GUID(){
    if (function_exists('com_create_guid') === true){
        return trim(com_create_guid(), '{}');
    }

    return sprintf('%04X%04X-%04X-%04X-%04X-%04X%04X%04X', mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(16384, 20479), mt_rand(32768, 49151), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535));
}

function uuid(){
    return strtolower(GUID());
}

function uuid_exists($uuid, &$pending){
    foreach($pending as $task){
        if($task->uuid == $uuid){
            return true;
        }
    }

    return false;
}

function iso8601_date(){
    $date = new DateTime();
    $entry = $date->format(DateTime::ISO8601);

    $entry = str_replace("-", "", $entry);
    $entry = str_replace(":", "", $entry);
    $entry = substr($entry, 0, -4);
    $entry = $entry . "Z";

    return $entry;
}
