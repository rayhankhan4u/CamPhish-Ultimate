<?php
// Template Engine
function render_template($name, $variables = []) {
    extract($variables);
    ob_start();
    include "templates/$name.html";
    return ob_get_clean();
}
?>
