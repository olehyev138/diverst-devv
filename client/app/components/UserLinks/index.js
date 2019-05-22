import React from "react";
import { connect } from "react-redux";
import { compose } from "redux";
import { createStructuredSelector } from "reselect";

import { AppBar, Toolbar, Button } from "@material-ui/core";
import { NavLink } from 'react-router-dom';
import { withTheme } from "@material-ui/core/styles";

export function HomePageLinks(props) {
  const { theme } = props;
  const activeColor = theme.palette.primary.main;

  const NavLinks = () => (
    <Toolbar
      style={{
        float: "none",
        marginLeft: "auto",
        marginRight: "auto"
      }}
    >
      <Button component={NavLink} to="/home" activeStyle={{ color: activeColor }}>Home</Button>
      <Button component={NavLink} to="/user/campaigns" activeStyle={{color: activeColor}}>Innovate</Button>
      <Button component={NavLink} to="/user/news" activeStyle={{color: activeColor}}>News</Button>
      <Button component={NavLink} to="/user/events" activeStyle={{color: activeColor}}>Events</Button>
      <Button component={NavLink} to="/user/groups" activeStyle={{color: activeColor}}>Inclusions Networks</Button>
      <Button>Mentorship</Button>
    </Toolbar>
  );

  return (
    <div>
      <AppBar position="static" style={{ backgroundColor: "white" }}>
        <NavLinks />
      </AppBar>
    </div>
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
)(withTheme()(HomePageLinks));