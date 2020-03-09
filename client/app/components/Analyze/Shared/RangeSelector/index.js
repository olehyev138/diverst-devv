/**
 *
 * RangeSelector Component
 *
 */

import React, { memo, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Grid, TextField, ButtonGroup,
} from '@material-ui/core';
import RefreshIcon from '@material-ui/icons/Cached';
import { withStyles } from '@material-ui/core/styles';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Analyze/messages';

const styles = theme => ({
  dateInput: {
    padding: '8.5px 10px',
  },
  refreshButton: {
    minWidth: 'initial',
    padding: '7px 10px',
  }
});

export function RangeSelector({ updateRange, classes }) {
  /* Formik doesnt quite fit our use case here, control form manually through local state
   * Use two separate range sets - to avoid buttons messing with custom input text
   */

  // Range values for pre defined buttons
  const [currentRange, setCurrentRange] = useState({
    from_date: '',
    to_date: ''
  });

  // Range values for 'custom' text inputs
  const [currentCustomRange, setCurrentCustomRange] = useState({
    from_date: '',
    to_date: ''
  });

  const handleRangeButtonClick = (rangeValue) => {
    // Handler for pre defined range buttons - range buttons only effect 'from_date'

    const newRange = { ...currentRange, from_date: rangeValue };

    setCurrentRange(newRange);
    setCurrentCustomRange({ from_date: '', to_date: '' });

    updateRange(newRange);
  };

  const handleRefreshButtonClick = () => {
    /* Handler for custom range inputs - submit is triggered by 'refresh' button
     * Serves as the 'all' or 'reset' button if custom inputs are clear
     */

    setCurrentRange({ from_date: '', to_date: '' });
    updateRange(currentCustomRange);
  };

  return (
    <Grid container spacing={2}>
      <Grid item>
        <ButtonGroup
          color='secondary'
          size='medium'
          variant='contained'
        >
          <Button
            id='range-1m'
            name='range-1m'
            disabled={currentRange.from_date === '1m'}
            onClick={() => handleRangeButtonClick('1m')}
          >
            {<DiverstFormattedMessage {...messages.selector.one_month} />}
          </Button>
          <Button
            id='name'
            name='name'
            disabled={currentRange.from_date === '3m'}
            onClick={() => handleRangeButtonClick('3m')}
          >
            {<DiverstFormattedMessage {...messages.selector.three_month} />}
          </Button>
          <Button
            id='name'
            name='name'
            disabled={currentRange.from_date === '6m'}
            onClick={() => handleRangeButtonClick('6m')}
          >
            {<DiverstFormattedMessage {...messages.selector.six_month} />}
          </Button>
          <Button
            id='name'
            name='name'
            disabled={currentRange.from_date === 'ytd'}
            onClick={() => handleRangeButtonClick('ytd')}
          >
            {<DiverstFormattedMessage {...messages.selector.YTD} />}
          </Button>
          <Button
            id='name'
            name='name'
            disabled={currentRange.from_date === '1y'}
            onClick={() => handleRangeButtonClick('1y')}
          >
            {<DiverstFormattedMessage {...messages.selector.one_year} />}
          </Button>
        </ButtonGroup>
      </Grid>
      <Grid item>
        <TextField
          margin='none'
          type='date'
          variant='outlined'
          id='name'
          name='name'
          helperText={<DiverstFormattedMessage {...messages.selector.from} />}
          onChange={e => setCurrentCustomRange({ ...currentCustomRange, from_date: e.target.value })}
          value={currentCustomRange.from_date}
          inputProps={{
            className: classes.dateInput
          }}
        />
      </Grid>
      <Grid item>
        <TextField
          margin='none'
          type='date'
          variant='outlined'
          id='name'
          name='name'
          helperText={<DiverstFormattedMessage {...messages.selector.to} />}
          onChange={e => setCurrentCustomRange({ ...currentCustomRange, to_date: e.target.value })}
          value={currentCustomRange.to_date}
          inputProps={{
            className: classes.dateInput
          }}
        />
      </Grid>
      <Grid item>
        <Button
          color='primary'
          size='small'
          variant='contained'
          className={classes.refreshButton}
          onClick={handleRefreshButtonClick}
        >
          <RefreshIcon />
        </Button>
      </Grid>
    </Grid>
  );
}

RangeSelector.propTypes = {
  updateRange: PropTypes.func.isRequired,
  classes: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles)
)(RangeSelector);
