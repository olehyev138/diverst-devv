import React from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import classNames from 'classnames';
import PropTypes from 'prop-types';
import { FormattedMessage } from 'react-intl';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import {
  AppBar, Toolbar, Button, Hidden, Menu, MenuItem, ListItemIcon, IconButton
} from '@material-ui/core';
import { NavLink } from 'react-router-dom';
import { matchPath } from 'react-router';
import { withStyles } from '@material-ui/core/styles';

import HomeIcon from '@material-ui/icons/HomeOutlined';
import LightbulbIcon from '@material-ui/icons/WbIncandescentOutlined';
import QuestionAnswerIcon from '@material-ui/icons/QuestionAnswerOutlined';
import EventIcon from '@material-ui/icons/EventOutlined';
import GroupIcon from '@material-ui/icons/GroupOutlined';
import CloudDownloadIcon from '@material-ui/icons/CloudDownloadOutlined';
import UsersCircleIcon from '@material-ui/icons/GroupWorkOutlined';
import DvrIcon from '@material-ui/core/SvgIcon/SvgIcon';
import ArrowDropDownIcon from '@material-ui/icons/ArrowDropDown';

import { ROUTES } from 'containers/Shared/Routes/constants';
import messages from 'containers/Session/LoginPage/messages';

const styles = theme => ({
  toolbar: {
    overflowX: 'auto',
    overflowY: 'hidden',
    whiteSpace: 'nowrap',
    display: 'block',
    backgroundColor: 'white',
    textAlign: 'center',
    minHeight: 'unset',
    maxHeight: 64,
    borderBottomWidth: 1,
    borderBottomStyle: 'solid',
    borderBottomColor: theme.custom.colors.lightGrey,
    paddingTop: 12,
  },
  mobileToolbar: {
    display: 'block',
    backgroundColor: 'white',
    textAlign: 'center',
    minHeight: 'unset',
    maxHeight: 64,
    borderBottomWidth: 1,
    borderBottomStyle: 'solid',
    borderBottomColor: theme.custom.colors.lightGrey,
  },
  navLinkActive: {
    color: theme.palette.primary.main,
    borderBottomColor: theme.palette.primary.main,
    borderBottomWidth: 1,
    borderBottomStyle: 'solid',
    borderBottomLeftRadius: 0,
    borderBottomRightRadius: 0,
    marginBottom: '0 !important',
    paddingBottom: '7px !important', // To account for the border size
  },
  navLink: {
    textAlign: 'center',
    fontSize: '0.9rem',
    fontWeight: 500,
    paddingTop: 4,
    paddingBottom: 4,
    paddingLeft: 8,
    paddingRight: 8,
    marginLeft: 6,
    marginRight: 6,
    marginBottom: 4,
  },
  navIcon: {
    marginRight: 4,
  },
  mobileNavToggleLink: {
    textAlign: 'center',
    fontSize: '1.1rem',
    textTransform: 'none',
    fontWeight: 500,
  },
  mobileNavLinkActive: {
    backgroundColor: 'rgba(0, 0, 0, 0.14)',
  },
  lightbulbIcon: {
    marginRight: 4,
    '-webkit-transform': 'rotate(180deg)',
    transform: 'rotate(180deg)',
  },
  arrowDropDownIcon: {
    '-webkit-transition': 'all 0.20s ease-in-out 0s',
    transition: 'all 0.20s ease-in-out 0s',
  },
  arrowDropDownIconRotated: {
    '-webkit-transform': 'rotate(180deg)',
    transform: 'rotate(180deg)',
  },
  paper: {
    borderWidth: 1,
    borderStyle: 'solid',
    borderColor: theme.custom.colors.grey,
  },
});

/* eslint-disable object-curly-newline */
export function MobileNavMenu({ classes, mobileNavAnchor, isMobileNavOpen, handleMobileNavClose }) {
  return (
    <Menu
      classes={{
        paper: classes.paper,
      }}
      id='mobileNav'
      disableAutoFocusItem
      anchorEl={mobileNavAnchor}
      getContentAnchorEl={null}
      elevation={0}
      anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
      transformOrigin={{ vertical: 'top', horizontal: 'center' }}
      open={isMobileNavOpen}
      onClose={handleMobileNavClose}
    >
    </Menu>
  );
}

export function NavLinks({ classes }) {
  return (
    <Toolbar className={classes.toolbar}>
      <Button
        component={WrappedNavLink}
        exact
        to={ROUTES.admin.system.globalSettings.fields.index.path()}
        className={classes.navLink}
        activeClassName={classes.navLinkActive}
      >
        Fields
      </Button>
    </Toolbar>
  );
}

/* eslint-disable react/no-multi-comp */
export class GlobalSettingsLinks extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      mobileNavAnchor: null,
    };
  }

  handleMobileNavOpen = (event) => {
    this.setState({ mobileNavAnchor: event.currentTarget });
  };

  handleMobileNavClose = () => {
    this.setState({ mobileNavAnchor: null });
  };

  render() {
    const { mobileNavAnchor } = this.state;
    const { classes, pageTitle } = this.props;
    const isMobileNavOpen = Boolean(mobileNavAnchor);

    // Wrap NavLink to fix ref issue temporarily until react-router-dom is updated to fix this
    /* eslint-disable-next-line react/no-multi-comp */

    return (
      <React.Fragment>
        <Hidden smUp>
          <Toolbar className={classes.mobileToolbar}>
            <Button
              className={classes.mobileNavToggleLink}
              aria-controls={
                isMobileNavOpen
                  ? 'mobileNav'
                  : undefined
              }
              aria-haspopup='true'
              onClick={this.handleMobileNavOpen}
            >
              <ArrowDropDownIcon className={classNames(classes.arrowDropDownIcon, isMobileNavOpen ? classes.arrowDropDownIconRotated : null)} />
              Page Title
            </Button>
          </Toolbar>
          <MobileNavMenu
            classes={classes}
            mobileNavAnchor={mobileNavAnchor}
            isMobileNavOpen={isMobileNavOpen}
            handleMobileNavClose={this.handleMobileNavClose}
          />
        </Hidden>
        <Hidden xsDown>
          <NavLinks classes={classes} />
        </Hidden>
      </React.Fragment>
    );
  }
}

MobileNavMenu.propTypes = {
  classes: PropTypes.object,
  mobileNavAnchor: PropTypes.object,
  isMobileNavOpen: PropTypes.bool,
  handleMobileNavClose: PropTypes.func
};

NavLinks.propTypes = {
  classes: PropTypes.object
};

GlobalSettingsLinks.propTypes = {
  classes: PropTypes.object,
  pageTitle: PropTypes.object,
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

export const StyledUserLinks = withStyles(styles)(GlobalSettingsLinks);

export default compose(
  withConnect,
  withStyles(styles),
)(GlobalSettingsLinks);
