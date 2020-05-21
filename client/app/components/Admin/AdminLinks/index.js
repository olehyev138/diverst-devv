import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import { matchPath } from 'react-router';

import {
  Collapse, Divider, Drawer, Hidden, List, ListItem, ListItemIcon, ListItemText, MenuItem,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

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
import { ROUTES } from 'containers/Shared/Routes/constants';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';
import WithPermission from 'components/Compositions/WithPermission';
import { permission } from 'utils/permissionsHelpers';
import dig from 'object-dig';

import Scrollbar from 'components/Shared/Scrollbar';

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
  },
  navLinkActive: {
    backgroundColor: 'rgba(0, 0, 0, 0.14)',
  },
});

const ListPermission = WithPermission(ListItem);
const MenuPermission = WithPermission(MenuItem);

class AdminLinks extends React.PureComponent {
  constructor(props) {
    super(props);

    this.state = {
      drawerOpen: props.drawerOpen,
      analyze: {
        open: !!matchPath(props.location.pathname, {
          path: ROUTES.admin.analyze.index.data.pathPrefix,
          exact: false,
          strict: false
        }),
      },
      manage: {
        open: !!matchPath(props.location.pathname, {
          path: ROUTES.admin.manage.index.data.pathPrefix,
          exact: false,
          strict: false
        }),
      },
      innovate: {
        open: !!matchPath(props.location.pathname, {
          path: ROUTES.admin.innovate.index.data.pathPrefix,
          exact: false,
          strict: false
        }),
      },
      plan: {
        open: !!matchPath(props.location.pathname, {
          path: ROUTES.admin.plan.index.data.pathPrefix,
          exact: false,
          strict: false
        }),
      },
      system: {
        open: !!matchPath(props.location.pathname, {
          path: ROUTES.admin.system.index.data.pathPrefix,
          exact: false,
          strict: false
        }),
      }
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

  handleManageClick = () => {
    this.setState(state => ({ manage: { open: !state.manage.open } }));
  };

  handlePlanClick = () => {
    this.setState(state => ({ plan: { open: !state.plan.open } }));
  };

  handleInnovateClick = () => {
    this.setState(state => ({ innovate: { open: !state.innovate.open } }));
  };

  handleSystemClick = () => {
    this.setState(state => ({ system: { open: !state.system.open } }));
  };

  drawer(classes) {
    return (
      <React.Fragment>
        <div className={classes.toolbar} />
        <Divider />
        <Scrollbar>
          <List>
            <ListPermission button onClick={this.handleAnalyzeClick} show={permission(this.props, 'metrics_overview')}>
              <ListItemIcon>
                <EqualizerIcon />
              </ListItemIcon>
              <ListItemText>
                <DiverstFormattedMessage {...ROUTES.admin.analyze.index.data.titleMessage} />
              </ListItemText>
              {this.state.analyze.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
            </ListPermission>
            <Collapse in={this.state.analyze.open} timeout='auto' unmountOnExit>
              <List disablePadding>
                <MenuPermission
                  component={WrappedNavLink}
                  exact
                  to={ROUTES.admin.analyze.overview.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'metrics_overview')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.analyze.overview.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.analyze.users.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'metrics_overview')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.analyze.users.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.analyze.groups.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'metrics_overview')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.analyze.groups.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.analyze.custom.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'metrics_overview')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.analyze.custom.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
              </List>
            </Collapse>

            <ListPermission
              button
              onClick={this.handleManageClick}
              show={
                permission(this.props, 'groups_create')
                || permission(this.props, 'segments_create')
                || permission(this.props, 'enterprise_folders_view')
                || permission(this.props, 'archive_manage')
              }
            >
              <ListItemIcon>
                <DeviceHubIcon />
              </ListItemIcon>
              <ListItemText>
                <DiverstFormattedMessage {...ROUTES.admin.manage.index.data.titleMessage} />
              </ListItemText>
              {this.state.manage.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
            </ListPermission>
            <Collapse in={this.state.manage.open} timeout='auto' unmountOnExit>
              <List disablePadding>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.manage.groups.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'groups_create')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.manage.groups.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.manage.segments.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'segments_create')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.manage.segments.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.manage.resources.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'enterprise_folders_view')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.manage.resources.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.manage.archived.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'archive_manage')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.manage.archived.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.manage.calendar.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'groups_calendars')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.manage.calendar.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
              </List>
            </Collapse>

            <ListPermission
              button
              onClick={this.handlePlanClick}
              show={
                dig(this.props, 'enterprise', 'plan_module_enabled')
                && permission(this.props, 'manage_all_budgets')
              }
            >
              <ListItemIcon>
                <AssignmentTurnedInIcon />
              </ListItemIcon>
              <ListItemText primary={<DiverstFormattedMessage {...ROUTES.admin.plan.index.data.titleMessage} />} />
              {this.state.plan.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
            </ListPermission>
            <Collapse in={this.state.plan.open} timeout='auto' unmountOnExit>
              <List disablePadding>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.plan.budgeting.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'manage_all_budgets')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    Group Budgets
                  </ListItemText>
                </MenuPermission>
              </List>
            </Collapse>

            <ListPermission
              button
              onClick={this.handleInnovateClick}
              show={permission(this.props, 'campaigns_create')}
            >
              <ListItemIcon>
                <LightbulbIcon className={classes.lightbulbIcon} />
              </ListItemIcon>
              <ListItemText primary={<DiverstFormattedMessage {...ROUTES.admin.innovate.index.data.titleMessage} />} />
              {this.state.innovate.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
            </ListPermission>
            <Collapse in={this.state.innovate.open} timeout='auto' unmountOnExit>
              <List disablePadding>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.innovate.campaigns.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'campaigns_create')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.innovate.campaigns.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.innovate.financials.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={permission(this.props, 'campaigns_manage')}
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.innovate.financials.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
              </List>
            </Collapse>

            <ListPermission
              button
              component={WrappedNavLink}
              to={ROUTES.admin.include.polls.index.path()}
              activeClassName={classes.navLinkActive}
              show={permission(this.props, 'polls_create')}
            >
              <ListItemIcon>
                <HowToVoteIcon />
              </ListItemIcon>
              <ListItemText primary={<DiverstFormattedMessage {...ROUTES.admin.include.index.data.titleMessage} />} />
            </ListPermission>

            <ListPermission
              button
              show={
                dig(this.props, 'enterprise', 'mentorship_module_enabled')
                && permission(this.props, 'mentoring_interests_create')
              }
            >
              <ListItemIcon>
                <UsersCircleIcon />
              </ListItemIcon>
              <ListItemText primary={<DiverstFormattedMessage {...ROUTES.admin.mentorship.index.data.titleMessage} />} />
            </ListPermission>

            <Divider />

            <ListPermission
              button
              onClick={this.handleSystemClick}
              show={
                permission(this.props, 'fields_manage')
                || permission(this.props, 'custom_text_manage')
                || permission(this.props, 'enterprise_manage')
                || permission(this.props, 'sso_authentication')
                || permission(this.props, 'emails_manage')
                || permission(this.props, 'users_create')
                || permission(this.props, 'policy_templates_create')
                || permission(this.props, 'branding_manage')
                || permission(this.props, 'integrations_manage')
                || permission(this.props, 'rewards_manage')
                || permission(this.props, 'logs_manage')
              }
            >
              <ListItemIcon>
                <SettingsIcon />
              </ListItemIcon>
              <ListItemText>
                <DiverstFormattedMessage {...ROUTES.admin.system.index.data.titleMessage} />
              </ListItemText>
              {this.state.system.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
            </ListPermission>
            <Collapse in={this.state.system.open} timeout='auto' unmountOnExit>
              <List disablePadding>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.system.globalSettings.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  isActive={(match, location) => !!matchPath(location.pathname, {
                    path: ROUTES.admin.system.globalSettings.pathPrefix,
                    exact: false,
                    strict: false,
                  })}
                  show={
                    permission(this.props, 'fields_manage')
                    || permission(this.props, 'custom_text_manage')
                    || permission(this.props, 'enterprise_manage')
                    || permission(this.props, 'sso_authentication')
                    || permission(this.props, 'emails_manage')
                  }
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.system.globalSettings.fields.index.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.system.users.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={
                    permission(this.props, 'users_create')
                    || permission(this.props, 'policy_templates_create')
                  }
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.system.users.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.system.branding.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={
                    permission(this.props, 'branding_manage')
                  }
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.system.branding.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to={ROUTES.admin.system.logs.index.path()}
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={
                    permission(this.props, 'logs_manage')
                  }
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.system.logs.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
                <MenuPermission
                  component={WrappedNavLink}
                  to='#'
                  className={classes.nested}
                  activeClassName={classes.navLinkActive}
                  show={
                    permission(this.props, 'integrations_manage')
                    || permission(this.props, 'rewards_manage')
                  }
                >
                  <ListItemIcon>
                    <ListIcon />
                  </ListItemIcon>
                  <ListItemText>
                    <DiverstFormattedMessage {...ROUTES.admin.system.diversity.index.data.titleMessage} />
                  </ListItemText>
                </MenuPermission>
              </List>
            </Collapse>

            <Divider />
          </List>
        </Scrollbar>
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
  location: PropTypes.object,
  permissions: PropTypes.object,
  enterprise: PropTypes.object,
};

export function mapDispatchToProps(dispatch) {
  return {
    dispatch
  };
}

const mapStateToProps = createStructuredSelector({
  permissions: selectPermissions(),
  enterprise: selectEnterprise(),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps
);

// styled & unconnected
export const StyledAdminLinks = withStyles(styles)(AdminLinks);

// styled & connected
export default compose(
  withConnect,
  withStyles(styles)
)(AdminLinks);
