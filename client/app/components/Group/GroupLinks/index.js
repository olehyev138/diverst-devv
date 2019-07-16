import React from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { AppBar, Toolbar, Button } from '@material-ui/core';
import { NavLink } from 'react-router-dom';
import { withTheme } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

export function GroupLinks(props) {
  const { theme } = props;
  const activeColor = theme.palette.primary.main;
  /* eslint-disable-next-line no-shadow */

  const NavLinks = () => (
    <Toolbar
      style={{
        float: 'none',
        marginLeft: 'auto',
        marginRight: 'auto'
      }}
    >
      <Button component={WrappedNavLink} to='/' activeStyle={{ color: activeColor }}>Home</Button>
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

GroupLinks.propTypes = {
  theme: PropTypes.object,
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
)(withTheme(GroupLinks));
