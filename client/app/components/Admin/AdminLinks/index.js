import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import { matchPath, useLocation } from 'react-router-dom';

import {
  Collapse, Divider, Drawer, Hidden, List, ListItem, ListItemIcon, ListItemText, MenuItem,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

// UI Icons
import ExpandLessIcon from '@material-ui/icons/ExpandLess';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';

// Shared Icons
import UsersIcon from '@material-ui/icons/People'; // Analyze & System
import GroupsIcon from '@material-ui/icons/SupervisedUserCircle'; // Analyze & Manage
import PlaceholderIcon from '@material-ui/icons/List'; // Placeholder

// Analyze
import AnalyzeIcon from '@material-ui/icons/Equalizer';
import AnalyzeOverviewIcon from '@material-ui/icons/ViewModule';
import AnalyzeCustomIcon from '@material-ui/icons/Poll';

// Manage
import ManageIcon from '@material-ui/icons/DeviceHub';
import ManageSegmentsIcon from '@material-ui/icons/Layers';
import ManageResourcesIcon from '@material-ui/icons/PermMedia';
import ManageArchiveIcon from '@material-ui/icons/Archive';
import ManageCalendarIcon from '@material-ui/icons/CalendarToday';

// Plan
import PlanIcon from '@material-ui/icons/AssignmentTurnedIn';
import PlanGroupBudgetsIcon from '@material-ui/icons/AttachMoney';

// Innovate
import InnovateIcon from '@material-ui/icons/WbIncandescent';

// Mentorship
import MentorshipIcon from '@material-ui/icons/GroupWork';

// Include
import IncludeIcon from '@material-ui/icons/HowToVote';

// System
import SystemIcon from '@material-ui/icons/Settings';
import SystemGlobalSettingsIcon from '@material-ui/icons/Tune';
import SystemBrandingIcon from '@material-ui/icons/Landscape';
import SystemLogsIcon from '@material-ui/icons/Book';

import { ROUTES } from 'containers/Shared/Routes/constants';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { selectAdminDrawerOpen, selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';
import WithPermission from 'components/Compositions/WithPermission';
import { permission } from 'utils/permissionsHelpers';
import dig from 'object-dig';

import Scrollbar from 'components/Shared/Scrollbar';

import { toggleAdminDrawer } from 'containers/Shared/App/actions';

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

export function AdminLinks(props) {
  const { classes, toggleAdminDrawer } = props;

  const ListPermission = WithPermission(ListItem);
  // Close admin drawer when you choose a navigation option
  const MenuPermission = WithPermission(props => <MenuItem onClick={() => toggleAdminDrawer(false)} {...props} />);

  const location = useLocation();

  const [state, setState] = useState({
    analyze: {
      open: !!matchPath(location.pathname, {
        path: ROUTES.admin.analyze.index.data.pathPrefix,
        exact: false,
        strict: false
      }),
    },
    manage: {
      open: !!matchPath(location.pathname, {
        path: ROUTES.admin.manage.index.data.pathPrefix,
        exact: false,
        strict: false
      }),
    },
    innovate: {
      open: !!matchPath(location.pathname, {
        path: ROUTES.admin.innovate.index.data.pathPrefix,
        exact: false,
        strict: false
      }),
    },
    plan: {
      open: !!matchPath(location.pathname, {
        path: ROUTES.admin.plan.index.data.pathPrefix,
        exact: false,
        strict: false
      }),
    },
    system: {
      open: !!matchPath(location.pathname, {
        path: ROUTES.admin.system.index.data.pathPrefix,
        exact: false,
        strict: false
      }),
    }
  });

  const handleAnalyzeClick = () => {
    setState({ ...state, analyze: { open: !state.analyze.open } });
  };

  const handleManageClick = () => {
    setState({ ...state, manage: { open: !state.manage.open } });
  };

  const handlePlanClick = () => {
    setState({ ...state, plan: { open: !state.plan.open } });
  };

  const handleInnovateClick = () => {
    setState({ ...state, innovate: { open: !state.innovate.open } });
  };

  const handleSystemClick = () => {
    setState({ ...state, system: { open: !state.system.open } });
  };

  const drawer = classes => (
    <React.Fragment>
      <div className={classes.toolbar} />
      <Divider />
      <Scrollbar>
        <List>
          <ListPermission button onClick={handleAnalyzeClick} show={permission(props, 'metrics_overview')}>
            <ListItemIcon>
              <AnalyzeIcon />
            </ListItemIcon>
            <ListItemText>
              <DiverstFormattedMessage {...ROUTES.admin.analyze.index.data.titleMessage} />
            </ListItemText>
            {state.analyze.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
          </ListPermission>
          <Collapse in={state.analyze.open} timeout='auto' unmountOnExit>
            <List disablePadding>
              <MenuPermission
                component={WrappedNavLink}
                exact
                to={ROUTES.admin.analyze.overview.path()}
                className={classes.nested}
                activeClassName={classes.navLinkActive}
                show={permission(props, 'metrics_overview')}
              >
                <ListItemIcon>
                  <AnalyzeOverviewIcon />
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
                show={permission(props, 'metrics_overview')}
              >
                <ListItemIcon>
                  <UsersIcon />
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
                show={permission(props, 'metrics_overview')}
              >
                <ListItemIcon>
                  <GroupsIcon />
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
                show={permission(props, 'metrics_overview')}
              >
                <ListItemIcon>
                  <AnalyzeCustomIcon />
                </ListItemIcon>
                <ListItemText>
                  <DiverstFormattedMessage {...ROUTES.admin.analyze.custom.index.data.titleMessage} />
                </ListItemText>
              </MenuPermission>
            </List>
          </Collapse>

          <ListPermission
            button
            onClick={handleManageClick}
            show={
              permission(props, 'groups_create')
              || permission(props, 'segments_create')
              || permission(props, 'enterprise_folders_view')
              || permission(props, 'archive_manage')
            }
          >
            <ListItemIcon>
              <ManageIcon />
            </ListItemIcon>
            <ListItemText>
              <DiverstFormattedMessage {...ROUTES.admin.manage.index.data.titleMessage} />
            </ListItemText>
            {state.manage.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
          </ListPermission>
          <Collapse in={state.manage.open} timeout='auto' unmountOnExit>
            <List disablePadding>
              <MenuPermission
                component={WrappedNavLink}
                to={ROUTES.admin.manage.groups.index.path()}
                className={classes.nested}
                activeClassName={classes.navLinkActive}
                show={permission(props, 'groups_create')}
              >
                <ListItemIcon>
                  <GroupsIcon />
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
                show={permission(props, 'segments_create')}
              >
                <ListItemIcon>
                  <ManageSegmentsIcon />
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
                show={permission(props, 'enterprise_folders_view')}
              >
                <ListItemIcon>
                  <ManageResourcesIcon />
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
                show={permission(props, 'archive_manage')}
              >
                <ListItemIcon>
                  <ManageArchiveIcon />
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
                show={permission(props, 'groups_calendars')}
              >
                <ListItemIcon>
                  <ManageCalendarIcon />
                </ListItemIcon>
                <ListItemText>
                  <DiverstFormattedMessage {...ROUTES.admin.manage.calendar.index.data.titleMessage} />
                </ListItemText>
              </MenuPermission>
            </List>
          </Collapse>
          <ListPermission
            button
            onClick={handlePlanClick}
            show={
              props?.enterprise?.plan_module_enabled
              && permission(props, 'manage_all_budgets')
            }
          >
            <ListItemIcon>
              <PlanIcon />
            </ListItemIcon>
            <ListItemText primary={<DiverstFormattedMessage {...ROUTES.admin.plan.index.data.titleMessage} />} />
            {state.plan.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
          </ListPermission>
          <Collapse in={state.plan.open} timeout='auto' unmountOnExit>
            <List disablePadding>
              <MenuPermission
                component={WrappedNavLink}
                to={ROUTES.admin.plan.budgeting.index.path()}
                className={classes.nested}
                activeClassName={classes.navLinkActive}
                show={permission(props, 'manage_all_budgets')}
              >
                <ListItemIcon>
                  <PlanGroupBudgetsIcon />
                </ListItemIcon>
                <ListItemText>
                  Group Budgets
                </ListItemText>
              </MenuPermission>
            </List>
          </Collapse>
          { /* Disable Innovate */ }
          <ListPermission
            button
            onClick={handleInnovateClick}
            show={false && permission(props, 'campaigns_create')}
          >
            <ListItemIcon>
              <InnovateIcon className={classes.lightbulbIcon} />
            </ListItemIcon>
            <ListItemText primary={<DiverstFormattedMessage {...ROUTES.admin.innovate.index.data.titleMessage} />} />
            {state.innovate.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
          </ListPermission>
          <Collapse in={state.innovate.open} timeout='auto' unmountOnExit>
            <List disablePadding>
              { /* Disable Innovate */ }
              <MenuPermission
                component={WrappedNavLink}
                to={ROUTES.admin.innovate.campaigns.index.path()}
                className={classes.nested}
                activeClassName={classes.navLinkActive}
                show={false && permission(props, 'campaigns_create')}
              >
                <ListItemIcon>
                  <PlaceholderIcon />
                </ListItemIcon>
                <ListItemText>
                  <DiverstFormattedMessage {...ROUTES.admin.innovate.campaigns.index.data.titleMessage} />
                </ListItemText>
              </MenuPermission>
              { /* Disable Innovate */ }
              <MenuPermission
                component={WrappedNavLink}
                to={ROUTES.admin.innovate.financials.index.path()}
                className={classes.nested}
                activeClassName={classes.navLinkActive}
                show={false && permission(props, 'campaigns_manage')}
              >
                <ListItemIcon>
                  <PlaceholderIcon />
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
            show={permission(props, 'polls_create')}
          >
            <ListItemIcon>
              <IncludeIcon />
            </ListItemIcon>
            <ListItemText primary={<DiverstFormattedMessage {...ROUTES.admin.include.index.data.titleMessage} />} />
          </ListPermission>

          { /* Disable Mentorship */ }
          <ListPermission
            button
            show={false
              && props?.enterprise?.mentorship_module_enabled
              && permission(props, 'mentoring_interests_create')
            }
          >
            <ListItemIcon>
              <MentorshipIcon />
            </ListItemIcon>
            <ListItemText primary={<DiverstFormattedMessage {...ROUTES.admin.mentorship.index.data.titleMessage} />} />
          </ListPermission>

          <Divider />

          <ListPermission
            button
            onClick={handleSystemClick}
            show={
              permission(props, 'fields_manage')
              || permission(props, 'custom_text_manage')
              || permission(props, 'enterprise_manage')
              || permission(props, 'sso_authentication')
              || permission(props, 'emails_manage')
              || permission(props, 'users_create')
              || permission(props, 'policy_templates_create')
              || permission(props, 'branding_manage')
              || permission(props, 'integrations_manage')
              || permission(props, 'rewards_manage')
              || permission(props, 'logs_manage')
            }
          >
            <ListItemIcon>
              <SystemIcon />
            </ListItemIcon>
            <ListItemText>
              <DiverstFormattedMessage {...ROUTES.admin.system.index.data.titleMessage} />
            </ListItemText>
            {state.system.open ? <ExpandLessIcon /> : <ExpandMoreIcon />}
          </ListPermission>
          <Collapse in={state.system.open} timeout='auto' unmountOnExit>
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
                  permission(props, 'fields_manage')
                  || permission(props, 'custom_text_manage')
                  || permission(props, 'enterprise_manage')
                  || permission(props, 'sso_authentication')
                  || permission(props, 'emails_manage')
                }
              >
                <ListItemIcon>
                  <SystemGlobalSettingsIcon />
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
                  permission(props, 'users_create')
                  || permission(props, 'policy_templates_create')
                }
              >
                <ListItemIcon>
                  <UsersIcon />
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
                  permission(props, 'branding_manage')
                }
              >
                <ListItemIcon>
                  <SystemBrandingIcon />
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
                  permission(props, 'logs_manage')
                }
              >
                <ListItemIcon>
                  <SystemLogsIcon />
                </ListItemIcon>
                <ListItemText>
                  <DiverstFormattedMessage {...ROUTES.admin.system.logs.index.data.titleMessage} />
                </ListItemText>
              </MenuPermission>
              {/* <MenuPermission */}
              {/*  component={WrappedNavLink} */}
              {/*  to='#' */}
              {/*  className={classes.nested} */}
              {/*  activeClassName={classes.navLinkActive} */}
              {/*  isActive={() => false} // Disable while there's no actual pages/paths so it doesn't show as active all the time */}
              {/*  show={ */}
              {/*    permission(props, 'integrations_manage') */}
              {/*    || permission(props, 'rewards_manage') */}
              {/*  } */}
              {/* > */}
              {/*  <ListItemIcon> */}
              {/*    <PlaceholderIcon /> */}
              {/*  </ListItemIcon> */}
              {/*  <ListItemText> */}
              {/*    <DiverstFormattedMessage {...ROUTES.admin.system.diversity.index.data.titleMessage} /> */}
              {/*  </ListItemText> */}
              {/* </MenuPermission> */}
            </List>
          </Collapse>

          <Divider />
        </List>
      </Scrollbar>
    </React.Fragment>
  );

  return (
    <nav className={classes.drawer}>
      <Hidden mdUp>
        <Drawer
          variant='temporary'
          open={props.drawerOpen}
          onClose={() => toggleAdminDrawer(false)}
          classes={{
            paper: classes.drawerPaper,
          }}
          ModalProps={{
            keepMounted: true, // Better open performance on mobile.
          }}
        >
          {drawer(classes)}
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
          {drawer(classes)}
        </Drawer>
      </Hidden>
    </nav>
  );
}

AdminLinks.propTypes = {
  classes: PropTypes.object,
  drawerToggleCallback: PropTypes.func,
  permissions: PropTypes.object,
  enterprise: PropTypes.object,
  drawerOpen: PropTypes.bool,
  toggleAdminDrawer: PropTypes.func,
};

const mapDispatchToProps = {
  toggleAdminDrawer,
};

const mapStateToProps = createStructuredSelector({
  permissions: selectPermissions(),
  enterprise: selectEnterprise(),
  drawerOpen: selectAdminDrawerOpen(),
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
