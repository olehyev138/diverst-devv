import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';

import {
  Collapse, Divider, Drawer, Hidden, List, ListItem, ListItemIcon, ListItemText
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import ExpandLessIcon from '@material-ui/icons/ExpandLess';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import EqualizerIcon from '@material-ui/icons/Equalizer';
import SettingsIcon from '@material-ui/icons/Settings';
import ListIcon from '@material-ui/icons/List';
import DeviceHubIcon from '@material-ui/icons/DeviceHub';
import AssignmentTurnedInIcon from '@material-ui/icons/AssignmentTurnedIn';
import LightbulbIcon from '@material-ui/icons/WbIncandescent';
import HowToVoteIcon from '@material-ui/icons/HowToVote';
import UsersCircleIcon from '@material-ui/icons/GroupWork';

const drawerWidth = 240;
const styles = theme => ({
  title: {
    display: 'none',
    [theme.breakpoints.up('sm')]: {
      display: 'block',
    },
  },
  sectionDesktop: {
    display: 'none',
    [theme.breakpoints.up('md')]: {
      display: 'flex',
    },
  },
  sectionMobile: {
    display: 'flex',
    [theme.breakpoints.up('md')]: {
      display: 'none',
    },
  },
  drawer: {
    [theme.breakpoints.up('md')]: {
      width: drawerWidth,
      flexShrink: 0,
    },
  },
  drawerPaper: {
    width: drawerWidth,
  },
  nested: {
    paddingLeft: theme.spacing(4),
  },
  toolbar: theme.mixins.toolbar,
  lightbulbIcon: {
    '-webkit-transform': 'rotate(180deg)',
    transform: 'rotate(180deg)',
  }
});

export class AdminLinks extends React.PureComponent {
  constructor(props) {
    super(props);

    this.state = {
      drawerOpen: props.drawerOpen,
      analyze: {
        open: false,
      },
    };
  }

  handleDrawerToggle = () => {
    this.setState(
      state => ({ drawerOpen: !state.drawerOpen }),
      () => (this.props.drawerToggleCallback(this.state.drawerOpen))
    );
  };

  handleAnalyzeClick = () => {
    this.setState(state => ({ analyze: { open: !state.analyze.open } }));
  };

  drawer(classes) {
    return (
      <React.Fragment>
        <div className={classes.toolbar} />
        <Divider />
        <List>
          <ListItem button onClick={this.handleAnalyzeClick}>
            <ListItemIcon>
              <EqualizerIcon />
            </ListItemIcon>
            <ListItemText primary='Analyze' />
            {this.state.analyze.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
          </ListItem>
          <Collapse in={this.state.analyze.open} timeout='auto' unmountOnExit>
            <List component='div' disablePadding>
              <ListItem button className={classes.nested}>
                <ListItemIcon>
                  <ListIcon />
                </ListItemIcon>
                <ListItemText primary='Users' />
              </ListItem>
            </List>
          </Collapse>

          <ListItem button>
            <ListItemIcon>
              <DeviceHubIcon />
            </ListItemIcon>
            <ListItemText primary='Manage' />
          </ListItem>

          <ListItem button>
            <ListItemIcon>
              <AssignmentTurnedInIcon />
            </ListItemIcon>
            <ListItemText primary='Plan' />
          </ListItem>

          <ListItem button>
            <ListItemIcon>
              <LightbulbIcon className={classes.lightbulbIcon} />
            </ListItemIcon>
            <ListItemText primary='Innovate' />
          </ListItem>

          <ListItem button>
            <ListItemIcon>
              <HowToVoteIcon />
            </ListItemIcon>
            <ListItemText primary='Include' />
          </ListItem>

          <ListItem button>
            <ListItemIcon>
              <UsersCircleIcon />
            </ListItemIcon>
            <ListItemText primary='Mentorship' />
          </ListItem>

          <Divider />

          <ListItem button>
            <ListItemIcon>
              <SettingsIcon />
            </ListItemIcon>
            <ListItemText
              primary='Global Settings'
            />
          </ListItem>

          <Divider />
        </List>
      </React.Fragment>
    );
  }

  render() {
    const { classes } = this.props;

    return (
      <nav className={classes.drawer}>
        <Hidden mdUp>
          <Drawer
            variant='temporary'
            open={this.state.drawerOpen}
            onClose={this.handleDrawerToggle}
            classes={{
              paper: classes.drawerPaper,
            }}
            ModalProps={{
              keepMounted: true, // Better open performance on mobile.
            }}
          >
            {this.drawer(classes)}
          </Drawer>
        </Hidden>
        <Hidden smDown>
          <Drawer
            classes={{
              paper: classes.drawerPaper,
            }}
            variant='permanent'
            open
          >
            {this.drawer(classes)}
          </Drawer>
        </Hidden>
      </nav>
    );
  }
}

AdminLinks.propTypes = {
  classes: PropTypes.object,
  drawerOpen: PropTypes.bool,
  drawerToggleCallback: PropTypes.func,
};

export function mapDispatchToProps(dispatch) {
  return {
    dispatch
  };
}

const mapStateToProps = createStructuredSelector({});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps
);

export default compose(
  withConnect,
  withStyles(styles)
)(AdminLinks);
