<?php
import('lib.pkp.classes.plugins.ThemePlugin');
class BoapThemePlugin extends ThemePlugin {

    /**
     * Load the custom styles for our theme
     * @return null
     */
    public function init() {
        // Use the parent theme's unique plugin slug
        $this->setParent('healthsciencesthemeplugin');
        //$this->modifyStyle('stylesheet', array('addLess' => array('styles/index.less')));
        $this->addStyle('child-stylesheet', 'styles/index.less');
    }

    /**
     * Get the display name of this theme
     * @return string
     */
    function getDisplayName() {
        return 'BOAP Theme';
    }

    /**
     * Get the description of this plugin
     * @return string
     */
    function getDescription() {
        return 'BOAP Theme.';
    }
}