import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { DiverstPagination } from '../../../Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';

const styles = theme => ({
  table: {
  },
  th: {
    'background-color': 'green',
    Color: 'white',
  },
  td: {
    width: '150px',
    'text-align': 'center',
    border: '1px solid black',
    padding: '5px',
  }
});

export function KPI(props) {
  const { classes, metrics } = props;

  const { __updates__, ...data } = metrics;

  return (
    Object.keys(metrics).length ? (
      <React.Fragment>
        <DiverstLoader isLoading={props.isFetching}>
          <table>
            <thead>
              <tr>
                <th>Metrics</th>
                {__updates__.map(update => (
                  <th>
                    {update.comments}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {Object.keys(data).map(key => (
                <tr>
                  <td>
                    {key}
                  </td>
                  { data[key].map(value => (
                    <td>
                      {`${value.value}, ${value.variance_with_prev}`}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </DiverstLoader>
        {Object.keys(metrics).length > 0 && (
          5
          // <DiverstPagination
          //   isLoading={props.isFetching}
          //   count={props.count}
          //   handlePagination={props.handlePagination}
          // />
        )}
      </React.Fragment>
    ) : (
      <React.Fragment />
    )
  );
}

KPI.propTypes = {
  classes: PropTypes.object,
  metrics: PropTypes.object,
  isFetching: PropTypes.bool,
  count: PropTypes.number,
  handlePagination: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles),
)(KPI);
