import React from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';

import { AppBar, Toolbar, Button } from '@material-ui/core';
import { NavLink } from 'react-router-dom';
import { withTheme } from '@material-ui/core/styles';

export function GroupLinks(props) {
  const { theme } = props;
  const activeColor = theme.palette.primary.main;
  // Wrap NavLink to fix ref issue temporarily until react-router-dom is updated to fix this
  const WrappedNavLink = React.forwardRef((props, ref) => <NavLink innerRef={ref} {...props} />);

  const NavLinks = () => (
    <Toolbar
      style={{
        float: 'none',
        marginLeft: 'auto',
        marginRight: 'auto'
      }}
    >
      <Button component={WrappedNavLink} to='/home' activeStyle={{ color: activeColor }}>Home</Button>
      <Button component={WrappedNavLink} to='/user/campaigns' activeStyle={{ color: activeColor }}>Members</Button>
      <Button component={WrappedNavLink} to='/user/news' activeStyle={{ color: activeColor }}>Events</Button>
      <Button component={WrappedNavLink} to='/user/events' activeStyle={{ color: activeColor }}>Resources</Button>
      <Button component={WrappedNavLink} to='/user/groups' activeStyle={{ color: activeColor }}>News Feed</Button>
      <Button component={WrappedNavLink} to='/user/groups' activeStyle={{ color: activeColor }}>Manage</Button>
      <Button component={WrappedNavLink} to='/user/groups' activeStyle={{ color: activeColor }}>Plan</Button>
    </Toolbar>
  );

  return (
    <div>
      <AppBar position='static' style={{ backgroundColor: 'white' }}>
        <NavLinks />
      </AppBar>
    </div>
  );
}

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
)(withTheme(GroupLinks));
