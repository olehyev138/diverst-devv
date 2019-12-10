import React from 'react';
import { compose } from 'redux';
import { withStyles, withTheme } from '@material-ui/core/styles';
import PropTypes from 'prop-types';
import Menu from '@material-ui/core/Menu';

import { FormControl, FormHelperText, FormLabel } from '@material-ui/core';

const styles = theme => ({

});

const AnchoredMenu = withStyles({
  paper: {
    border: '1px solid #d3d4d5',
  },
})(props => (
  <Menu
    elevation={0}
    getContentAnchorEl={null}
    anchorOrigin={{
      vertical: 'bottom',
      horizontal: 'center',
    }}
    transformOrigin={{
      vertical: 'top',
      horizontal: 'center',
    }}
    {...props}
  />
));

export function DiverstDropdownMenu({ anchor, setAnchor, id, ...rest }) {
  const handleClose = () => {
    setAnchor(null);
  };

  return (
    <React.Fragment>
      <AnchoredMenu
        id={id}
        anchorEl={anchor}
        keepMounted
        open={Boolean(anchor)}
        onClose={handleClose}
        {...rest}
      >
        {rest.children}
      </AnchoredMenu>
    </React.Fragment>
  );
}

DiverstDropdownMenu.propTypes = {
  id: PropTypes.string,
  anchor: PropTypes.object,
  setAnchor: PropTypes.func.isRequired,
};

export default compose(
  withTheme,
  withStyles(styles),
)(DiverstDropdownMenu);
