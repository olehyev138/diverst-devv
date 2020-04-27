import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { FormControl, InputLabel, Select, MenuItem, TextField } from '@material-ui/core';

import messages from 'containers/Shared/LocaleToggle/messages';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

const styles = theme => ({
  formControl: {
    margin: 6,
  },
});

const LANGUAGE_SELECT_LABEL_ID = 'diverst-language-select-label';

export function DiverstLanguageSelect(props) {
  const { classes, values, onToggle, ...rest } = props;

  return (
    <React.Fragment>
      <FormControl variant='outlined' className={classes.formControl}>
        <InputLabel id={LANGUAGE_SELECT_LABEL_ID}>
          <DiverstFormattedMessage {...messages.language} />
        </InputLabel>
        <Select
          onChange={onToggle}
          labelId={LANGUAGE_SELECT_LABEL_ID}
          label={<DiverstFormattedMessage {...messages.language} />}
          {...rest}
        >
          {values && values.map(option => (
            <MenuItem value={option} key={option}>
              <DiverstFormattedMessage {...messages.locales[option]} />
            </MenuItem>
          ))}
        </Select>
      </FormControl>
    </React.Fragment>
  );
}

DiverstLanguageSelect.propTypes = {
  classes: PropTypes.object,
  values: PropTypes.array,
  onToggle: PropTypes.func,
};

export default compose(
  withStyles(styles),
  memo,
)(DiverstLanguageSelect);
