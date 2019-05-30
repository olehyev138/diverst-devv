import React from "react";
import { connect } from "react-redux";
import { compose } from "redux";
import { createStructuredSelector } from "reselect";

import { AppBar, Toolbar, Button } from "@material-ui/core";
import { NavLink } from 'react-router-dom';
import { withStyles } from "@material-ui/core/styles";

import HomeIcon from "@material-ui/icons/HomeOutlined";
import LightbulbIcon from "@material-ui/icons/WbIncandescentOutlined";
import QuestionAnswerIcon from "@material-ui/icons/QuestionAnswerOutlined";
import EventIcon from "@material-ui/icons/EventOutlined";
import GroupIcon from "@material-ui/icons/GroupOutlined";
import UsersCircleIcon from "@material-ui/icons/GroupWorkOutlined";

const styles = theme => ({
  toolbar: {
    backgroundColor: 'white',
    justifyContent: 'center',
    minHeight: 'unset',
    maxHeight: 64,
    borderBottomWidth: 1,
    borderBottomStyle: 'solid',
    borderBottomColor: theme.custom.colors.lightGrey,
    paddingTop: 12,
  },
  navLinkActive: {
    color: theme.palette.primary.main,
    borderBottomColor: theme.palette.primary.main,
    borderBottomWidth: 1,
    borderBottomStyle: 'solid',
    borderBottomLeftRadius: 0,
    borderBottomRightRadius: 0,
    marginBottom: "0 !important",
    paddingBottom: "7px !important", // To account for the border size
  },
  navLink: {
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
  lightbulbIcon: {
    marginRight: 4,
    '-webkit-transform': 'rotate(180deg)',
    transform: 'rotate(180deg)',
  }
});

export function UserLinks(props) {
  const { classes } = props;
  // Wrap NavLink to fix ref issue temporarily until react-router-dom is updated to fix this
  const WrappedNavLink = React.forwardRef((props, ref) => <NavLink innerRef={ref} {...props} />);

  const NavLinks = () => (
    <Toolbar className={classes.toolbar}>
      <Button component={WrappedNavLink} to="/" className={classes.navLink} activeClassName={classes.navLinkActive}><HomeIcon className={classes.navIcon} /> Home</Button>
      <Button component={WrappedNavLink} to="/user/campaigns" className={classes.navLink} activeClassName={classes.navLinkActive}><LightbulbIcon className={classes.lightbulbIcon} /> Innovate</Button>
      <Button component={WrappedNavLink} to="/user/news" className={classes.navLink} activeClassName={classes.navLinkActive}><QuestionAnswerIcon className={classes.navIcon} /> News</Button>
      <Button component={WrappedNavLink} to="/user/events" className={classes.navLink} activeClassName={classes.navLinkActive}><EventIcon className={classes.navIcon} /> Events</Button>
      <Button component={WrappedNavLink} to="/user/groups" className={classes.navLink} activeClassName={classes.navLinkActive}><GroupIcon className={classes.navIcon} /> Inclusion Networks</Button>
      <Button component={WrappedNavLink} to="/user/groups" className={classes.navLink} activeClassName={classes.navLinkActive}><UsersCircleIcon className={classes.navIcon} /> Mentorship</Button>
    </Toolbar>
  );

  return (
    <NavLinks />
  );
}

export function mapDispatchToProps(dispatch) {
  return {
    dispatch
  }
}

const mapStateToProps = createStructuredSelector({});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps
);

export default compose(
  withConnect,
)(withStyles(styles)(UserLinks));
