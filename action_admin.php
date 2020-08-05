<?php

include('session.php');

if (isset($_POST['action'])){
  if ($_POST['action'] == 'edit') {
    $val = $_POST['value'];
    $pk = $_POST['pk'];

    if($_POST['col'] == 0){
      //$sql_query = "update user set usr_id='$val' where usr_id='$pk'";
      echo 'ERR - id non modificabile';
      //$sql_exec = mysqli_query($db, $sql_query);
    }else if($_POST['col'] == 1){
      $sql_query = "update user set email='$val' where usr_id='$pk'";
      echo $sql_query;
      $sql_exec = mysqli_query($db, $sql_query);
    }else if($_POST['col'] == 2){
      $sql_query = "update user set passwd=sha1('$val') where usr_id='$pk'";
      echo $sql_query;
      $sql_exec = mysqli_query($db, $sql_query);
    }else if($_POST['col'] == 4){
      if($val == 'true'){
        $val='S';
      }else if($val == 'false'){
        $val='N';
      };
      $sql_query = "update user set admin='$val' where usr_id='$pk'";
      echo $sql_query;
      $sql_exec = mysqli_query($db, $sql_query);
    }else if($_POST['col'] == 5){
      if($val == 'true'){
        $val='S';
      }else if($val == 'false'){
        $val='N';
      };
      $sql_query = "update user set valid='$val' where usr_id='$pk'";
      echo $sql_query;
      $sql_exec = mysqli_query($db, $sql_query);
    }else if($_POST['col'] == 6){
      $sql_query = "update user set color=substr('$val',2,6) where usr_id='$pk'";
      echo $sql_query;
      $sql_exec = mysqli_query($db, $sql_query);
    };
  }elseif ($_POST['action'] == 'save') {
    $usrid = $_POST['usrid'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $admin = $_POST['admin'];
    $valid = $_POST['valid'];
    $color = $_POST['color'];

    if($valid == 'true'){
      $valid='S';
    }else if($valid == 'false'){
      $valid='N';
    };
    if($admin == 'true'){
      $admin='S';
    }else if($admin == 'false'){
      $admin='N';
    };

    $sql_query = "insert into user (usr_id, email, passwd, admin, valid, color) values ('$usrid', '$email', sha1('$password'), '$admin', '$valid', substr('$color',2,6))";
    echo $sql_query;
    $sql_exec = mysqli_query($db, $sql_query);
  }elseif ($_POST['action'] == 'delete') {
    $pk = $_POST['pk'];
    $sql_query = "delete from user where usr_id ='$pk'";
    echo $sql_query;
    $sql_exec = mysqli_query($db, $sql_query);
  };
};

// get detail
$sql_query = "SELECT CONCAT('[', GROUP_CONCAT(JSON_OBJECT('id', usr_id, 'email', email, 'password', '', 'last_login', tms_upd, 'admin', case when admin='S' then TRUE ELSE FALSE end, 'active', case when valid='S' then TRUE ELSE FALSE end, 'color', concat('#',color))),']') as value FROM user";
$sql_exec = mysqli_query($db, $sql_query);
$sql_row = mysqli_fetch_array($sql_exec, MYSQLI_ASSOC);
//echo $sql_row['value'];

$file = fopen('results_user.json', 'w');
fwrite($file, $sql_row['value']);
fclose($file);
?>
